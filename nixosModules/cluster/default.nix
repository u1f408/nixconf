{ config
, pkgs
, lib
, std
, ...
}:

with lib;
let
  cfg = config.iris.cluster;

in
{
  options.iris.cluster = {
    enable = mkEnableOption "cluster service configuration" // { default = false; };

    datacenter = mkOption {
      type = types.str;
      description = ''
        Datacenter name for this cluster
      '';
    };

    isController = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether this node should run the cluster controller services
      '';
    };
  };

  config = {
    iris.allowUnfreePackages = optionals cfg.enable [
      "nomad"
      "consul"
    ];

    virtualisation.containers.enable = mkIf cfg.enable (mkForce true);
    virtualisation.docker.enable = mkIf cfg.enable (mkForce true);

    systemd.services.consul = mkIf cfg.enable {
      serviceConfig.Type = "notify";
    };

    services.consul = mkIf cfg.enable {
      enable = true;
      dropPrivileges = false;

      webUi = mkIf cfg.isController true;

      forceAddrFamily = "ipv4";
      extraConfig = (mkMerge [
        {
          client_addr = "{{ GetInterfaceIP \"tailscale0\" }}";
          advertise_addr = "{{ GetInterfaceIP \"tailscale0\" }}";

          datacenter = cfg.datacenter;
          retry_join = [ "consul.service.${cfg.datacenter}.dc.consul" ];
          connect.enabled = true;

          addresses = {
            grpc = "{{ GetInterfaceIP \"tailscale0\" }} unix:///run/consul-${cfg.datacenter}-grpc.sock";
            http = "{{ GetInterfaceIP \"tailscale0\" }} unix:///run/consul-${cfg.datacenter}-http.sock";
          };

          ports = {
            dns = 53;
            grpc = 8502;
          };
        }

        (mkIf cfg.isController {
          server = true;
          bootstrap_expect = 1;
        })
      ]);
    };

    systemd.services.nomad = mkIf cfg.enable {
      serviceConfig.after = [ "consul.service" ];
    };

    services.nomad = mkIf cfg.enable {
      enable = true;
      enableDocker = true;
      dropPrivileges = false;

      extraPackages = with pkgs; [
        consul
        cni-plugins
      ];

      settings = (mkMerge [
        {
          datacenter = cfg.datacenter;
          bind_addr = "{{ GetInterfaceIP \"tailscale0\" }}";
          consul = {
            ssl = false;
            address = "unix:///run/consul-${cfg.datacenter}-http.sock";
            grpc_address = "unix:///run/consul-${cfg.datacenter}-grpc.sock";
          };

          client = {
            enabled = true;
            cni_path = "${pkgs.cni-plugins}/bin";
          };
        }

        (mkIf cfg.isController {
          client.node_pool = "controller";
          server = {
            enabled = true;
            bootstrap_expect = 1;
          };
        })
      ]);
    };
  };
}
