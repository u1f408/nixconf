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
  config = {
    iris.allowUnfreePackages = optionals cfg.enable [ "consul" ];

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
          unix_sockets = {
            group = "${toString config.ids.gids.vault}";
            mode = "775";
          };

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
  };
}
