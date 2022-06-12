{ inputs, meta, config, pkgs, lib ? pkgs.lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    virtualHosts."${config.networking.fqdn}" = {
      default = true;
      rejectSSL = true;

      locations."/".return = "301 https://$host$request_uri";

      locations."= /.well-known/irisbox.json" =
        let
          meow = rec {
            host = config.networking.hostName;
            fqdn = config.networking.fqdn;
            running = "NixOS";
          };

          output = builtins.replaceStrings [ "'" ] [ "\'" ] (builtins.toJSON meow);

        in
        {
          extraConfig = ''
            add_header Content-Type 'application/json';
            return 200 '${output}';
          '';
        };
    };
  };
}
