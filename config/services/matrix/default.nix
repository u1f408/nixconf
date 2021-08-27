{ config, lib, pkgs, meta, ... }:

let
  matrixDomain = "smol.systems";
  serverFqdn =
    let
      join = hostName: domain: hostName + lib.optionalString (domain != null) ".${domain}";
    in join config.networking.hostName config.networking.domain;

in
{
  imports = [ ];

  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE="C"
        LC_CTYPE="C";
    '';
  };

  services.matrix-synapse = {
    enable = true;
    server_name = matrixDomain;

    listeners = [
      {
        port = 8008;
        bind_address = "::1";
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [
          {
            names = [ "client" "federation" ];
            compress = false;
          }
        ];
      }
    ];
  };

  services.nginx.virtualHosts = {
    ${matrixDomain} = {
      enableACME = true;
      forceSSL = true;

      locations."= /.well-known/matrix/server".extraConfig =
        let
          server = { "m.server" = "${serverFqdn}:443"; };
        in ''
          add_header Content-Type application/json;
          return 200 '${builtins.toJSON server}';
        '';

      locations."= /.well-known/matrix/client".extraConfig =
        let
          client = {
            "m.homeserver" = { "base_url" = "https://${serverFqdn}"; };
            "m.identity_server" = { "base_url" = "https://vector.im"; };
          };
        in ''
          add_header Content-Type application/json;
          add_header Access-Control-Allow-Origin *;
          return 200 '${builtins.toJSON client}';
        '';
    };

    ${serverFqdn} = {
      enableACME = true;
      forceSSL = true;

      locations."/_matrix" = {
        proxyPass = "http://[::1]:8008";
      };
    };
  };
}
