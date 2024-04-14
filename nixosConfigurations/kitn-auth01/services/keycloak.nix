{ config
, meta
, pkgs
, lib
, ...
}:

let
  keycloakSecretConf = {
    mode = "770";
    owner = "keycloak";
    group = "keycloak";
  };

in
{
  age.secrets = {
    "keycloak-db-password" = keycloakSecretConf // {
      file = "${meta}/secrets/keycloak-db-password.age";
    };
  };

  users.groups.keycloak = { gid = 114; };
  users.users.keycloak = { uid = 114; isSystemUser = true; group = "keycloak"; };
  systemd.services.keycloak.serviceConfig.DynamicUser = lib.mkForce false;
  services.keycloak = {
    enable = true;
    database = {
      type = "postgresql";
      username = "keycloak";
      passwordFile = config.age.secrets."keycloak-db-password".path;
    };

    settings = {
      http-enabled = true;
      http-host = "127.0.0.1";
      http-port = 17179;
      proxy = "edge";
      proxy-headers = "xforwarded";
      hostname = "auth.soupnet.cc";
    };
  };
}
