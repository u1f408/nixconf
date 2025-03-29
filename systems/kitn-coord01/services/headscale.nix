{ config
, meta
, pkgs
, lib
, ...
}:

{
  age.secrets =
    let
      svcSecret = user: fn: {
        file = meta.outPath + "/secrets/${fn}";
        mode = "660";
        owner = user;
        group = user;
      };

    in
    {
      "headscale-oidc-client-secret" = svcSecret "headscale" "headscale-oidc-client-secret.age";
    };

  users = {
    users.headscale = { isSystemUser = true; group = "headscale"; };
    groups.headscale = { };
  };

  services.caddy.virtualHosts."hs.soupnet.cc" = {
    extraConfig = ''
      @grpc protocol grpc
      handle @grpc {
        reverse_proxy h2c://${builtins.toString config.services.headscale.settings.grpc_listen_addr}
      }

      handle {
        reverse_proxy 127.0.0.1:${builtins.toString config.services.headscale.port}
      }
    '';
  };

  environment.systemPackages = [
    config.services.headscale.package
  ];

  services.headscale = {
    enable = true;
    user = "headscale";
    group = "headscale";
    port = 17091;

    settings = {
      server_url = "https://hs.soupnet.cc";
      grpc_listen_addr = "127.0.0.1:17092";
      grpc_allow_insecure = true;
      disable_check_updates = true;
      derp.server.enabled = false;
      policy.mode = "database";

      prefixes = {
        v4 = "";
        allocation = "random";
      };

      dns = {
        magic_dns = true;
        base_domain = "hs.soupnet.cc";
        nameservers.global = [ "1.1.1.1" "1.0.0.1" ];
      };

      oidc = {
        only_start_if_oidc_is_available = true;
        issuer = "https://idm.soupnet.cc";
        client_id = "headscale-soupnet";
        client_secret_path = config.age.secrets."headscale-oidc-client-secret".path;
        scope = [ "openid" "profile" "email" ];
        allowed_domains = [ "soupnet.cc" ];
        strip_email_domain = true;
      };
    };
  };
}
