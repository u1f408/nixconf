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
      "lldap-key-seed" = svcSecret "lldap" "lldap-key-seed.age";
      "lldap-jwt-secret" = svcSecret "lldap" "lldap-jwt-secret.age";
      "lldap-admin-password" = svcSecret "lldap" "lldap-admin-password.age";

      "authelia-jwt-secret" = svcSecret "authelia" "authelia-jwt-secret.age";
      "authelia-session-secret" = svcSecret "authelia" "authelia-session-secret.age";
      "authelia-storage-encryption-key" = svcSecret "authelia" "authelia-storage-encryption-key.age";
      "authelia-ldap-bind-password" = svcSecret "authelia" "authelia-ldap-bind-password.age";
      "authelia-oidc-hmac-secret" = svcSecret "authelia" "authelia-oidc-hmac-secret.age";
      "authelia-oidc-issuer-key" = svcSecret "authelia" "authelia-oidc-issuer-key.age";
      "authelia-oidc-clients.yaml" = svcSecret "authelia" "authelia-oidc-clients.yaml.age";
    };

  users = {
    users = {
      lldap = { isSystemUser = true; group = "lldap"; };
      authelia = { isSystemUser = true; group = "authelia"; };
    };

    groups = {
      lldap = { };
      authelia = { };
    };
  };

  environment.systemPackages = [
    config.services.authelia.instances.soupnet.package
  ];

  services.caddy.virtualHosts."idm.soupnet.cc" = {
    extraConfig = ''
      redir /lldap /lldap/
      handle_path /lldap/* {
        reverse_proxy 127.0.0.1:${builtins.toString config.services.lldap.settings.http_port}
      }

      handle {
        reverse_proxy 127.0.0.1:9091
      }
    '';
  };

  services.postgresql = {
    ensureDatabases = [ "lldap" "authelia" ];
    ensureUsers = [
      { name = "lldap"; ensureDBOwnership = true; }
      { name = "authelia"; ensureDBOwnership = true; }
    ];
  };

  services.lldap = {
    enable = true;
    package = pkgs.lldap;

    environment = {
      LLDAP_KEY_SEED_FILE = config.age.secrets."lldap-key-seed".path;
      LLDAP_JWT_SECRET_FILE = config.age.secrets."lldap-jwt-secret".path;
      LLDAP_LDAP_USER_PASS_FILE = config.age.secrets."lldap-admin-password".path;
    };

    settings = {
      database_url = "postgres:///lldap";
      http_url = "https://idm.soupnet.cc/lldap";
      ldap_base_dn = "dc=soupnet,dc=cc";

      ldaps_options.enable = false;
      smtp_options.enable_password_reset = false;
    };
  };

  services.redis.servers.authelia = {
    enable = true;
    user = "authelia";
    group = "authelia";

    save = [ ];
  };

  services.authelia.instances.soupnet = {
    enable = true;
    user = "authelia";
    group = "authelia";

    secrets = {
      jwtSecretFile = config.age.secrets."authelia-jwt-secret".path;
      sessionSecretFile = config.age.secrets."authelia-session-secret".path;
      storageEncryptionKeyFile = config.age.secrets."authelia-storage-encryption-key".path;
      oidcHmacSecretFile = config.age.secrets."authelia-oidc-hmac-secret".path;
      oidcIssuerPrivateKeyFile = config.age.secrets."authelia-oidc-issuer-key".path;
    };

    environmentVariables = {
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = config.age.secrets."authelia-ldap-bind-password".path;
    };

    settingsFiles = [
      config.age.secrets."authelia-oidc-clients.yaml".path
    ];

    settings = {
      theme = "auto";
      identity_validation.reset_password.jwt_lifespan = "15 minutes";

      access_control = {
        default_policy = "deny";
        rules = [
          { domain = "*.soupnet.cc"; policy = "one_factor"; }
        ];
      };

      authentication_backend = {
        password_reset.disable = false;
        refresh_interval = "1m";
        ldap = {
          implementation = "lldap";
          address = "ldap://127.0.0.1:3890";
          base_dn = config.services.lldap.settings.ldap_base_dn;
          user = "uid=bind_authelia,ou=people,${config.services.lldap.settings.ldap_base_dn}";
        };
      };

      storage.postgres = {
        address = "unix:///run/postgresql";
        database = "authelia";
        username = "authelia";
        password = "unused-for-peer-auth";
      };

      session = {
        redis.host = config.services.redis.servers.authelia.unixSocket;
        cookies = [
          { domain = "soupnet.cc"; authelia_url = "https://idm.soupnet.cc"; }
        ];
      };

      notifier = {
        disable_startup_check = false;
        filesystem.filename = "/tmp/authelia-notifier.txt";
      };
    };
  };
}
