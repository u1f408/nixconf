{ config
, meta
, pkgs
, lib
, ...
}:

let
  lldapSecretConf = {
    mode = "770";
    owner = "lldap";
    group = "lldap";
  };

in
{
  age.secrets = {
    "lldap-jwt-secret" = lldapSecretConf // {
      file = "${meta}/secrets/lldap-jwt-secret.age";
    };
    "lldap-key-seed" = lldapSecretConf // {
      file = "${meta}/secrets/lldap-key-seed.age";
    };
  };

  users.groups.lldap = { gid = 99; };
  users.users.lldap = { uid = 99; isSystemUser = true; group = "lldap"; };
  systemd.services.lldap.serviceConfig.DynamicUser = lib.mkForce false;
  services.lldap = {
    enable = true;

    environment.LLDAP_JWT_SECRET_FILE = config.age.secrets."lldap-jwt-secret".path;
    environment.LLDAP_KEY_SEED_FILE = config.age.secrets."lldap-key-seed".path;
    settings = {
      http_host = "127.0.0.1";
      ldap_host = "127.0.0.1";
      ldap_base_dn = "dc=soupnet,dc=cc";
      database_url = "postgres:///lldap";
    };
  };
}
