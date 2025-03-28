let
  inherit (import <nixpkgs> { }) lib;
  readSshKeyFile =
    (file: with builtins; with lib; split "\s*\n" (readFile file));

  keys = rec {
    users.iris = readSshKeyFile ../users/iris/authorized_keys;
    systems = {
      kitn-coord01 = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlmxmKlb3rVpeiZaYc2LPR6P65n37H5zuiqA5U7JGgz"
      ];
    };
  };

  keysets = {
    kitn-coord01 = lib.flatten (with keys; [ users.iris systems.kitn-coord01 ]);
  };

in
{
  "lldap-key-seed.age".publicKeys = keysets.kitn-coord01;
  "lldap-jwt-secret.age".publicKeys = keysets.kitn-coord01;
  "lldap-admin-password.age".publicKeys = keysets.kitn-coord01;

  "authelia-jwt-secret.age".publicKeys = keysets.kitn-coord01;
  "authelia-session-secret.age".publicKeys = keysets.kitn-coord01;
  "authelia-storage-encryption-key.age".publicKeys = keysets.kitn-coord01;
  "authelia-ldap-bind-password.age".publicKeys = keysets.kitn-coord01;
  "authelia-oidc-hmac-secret.age".publicKeys = keysets.kitn-coord01;
  "authelia-oidc-issuer-key.age".publicKeys = keysets.kitn-coord01;
  "authelia-oidc-clients.yaml.age".publicKeys = keysets.kitn-coord01;

  "headscale-oidc-client-secret.age".publicKeys = keysets.kitn-coord01;
}
