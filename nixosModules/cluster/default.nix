{ config
, pkgs
, lib
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

  config = mkIf cfg.enable (mkMerge [
    {
      iris.allowUnfreePackages = [
        "nomad"
        "consul"
      ];

      virtualisation.containers.enable = true;
      virtualisation.docker.enable = true;

      services.consul = {
        enable = true;
        dropPrivileges = false;

        forceAddrFamily = "ipv4";
        interface.bind = "tailscale0";
        interface.advertise = "tailscale0";

        extraConfig = {
          client_addr = "0.0.0.0";
          datacenter = cfg.datacenter;
          retry_join = "consul.service.${cfg.datacenter}.dc.consul";

          connect.enabled = true;
          ports.grpc = 8502;
        };
      };

      services.nomad = {
        enable = true;
        enableDocker = true;
        dropPrivileges = true;

        extraPackages = with pkgs; [
          consul
          cni-plugins
        ];

        settings = {
          datacenter = cfg.datacenter;
          bind_addr = "0.0.0.0";
          consul.ssl = false;

          client = {
            enabled = true;
            cni_path = "${pkgs.cni-plugins}/bin";
          };
        };
      };
    }

    (mkIf cfg.isController {
      services.consul = {
        webUi = true;
        extraConfig = {
          server = true;
          bootstrap_expect = 1;
          ports.dns = 53;
        };
      };

      services.nomad = {
        settings = {
          client.node_pool = "controller";

          server = {
            enabled = true;
            bootstrap_expect = 1;
          };
        };
      };
    })
  ]);
}
