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
  config = mkIf cfg.enable {
    iris.allowUnfreePackages = optionals cfg.enable [ "nomad" ];
    virtualisation.containers.enable = mkIf cfg.enable (mkForce true);
    virtualisation.docker.enable = mkIf cfg.enable (mkForce true);

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

        {
          plugin = [{
            docker.config = {
              allow_privileged = true;
            };
          }];
        }

        (mkIf cfg.isController {
          client.node_pool = "controller";
          server = {
            enabled = true;
            bootstrap_expect = 1;
          };

          vault = {
            enabled = true;
            address = "http://vault.service.consul:8200";
            create_from_role = "nomad-cluster";
          };
        })
      ]);

      extraSettingsPaths = [
        "/root/nomad-vault.hcl"
      ];
    };
  };
}
