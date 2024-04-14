let
  nixpkgs =
    (import
      (let lock = builtins.fromJSON (builtins.readFile ../flake.lock); in fetchTarball {
        url = lock.nodes.nixpkgs.locked.url or "https://github.com/nixos/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
        sha256 = lock.nodes.nixpkgs.locked.narHash;
      }) {});
in

with builtins;
with nixpkgs.lib;

let
  readKeyFile = path: (filter (f: f != "") (splitString "\n" (readFile path)));

  users = {
    iris = readKeyFile ../nixosModules/users/sshKeys/iris;
  };

  systems = {
    kitn-auth01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOC1ax6OIwRHrOlWUgq5LkVvK8u2Mp/3s1qq1X2DRkTU";
  };

in
{
  "lldap-jwt-secret.age".publicKeys = (flatten [ users.iris systems.kitn-auth01 ]);
  "lldap-key-seed.age".publicKeys = (flatten [ users.iris systems.kitn-auth01 ]);

  "keycloak-db-password.age".publicKeys = (flatten [ users.iris systems.kitn-auth01 ]);
  "keycloak-ldap-bind-password.age".publicKeys = (flatten [ users.iris systems.kitn-auth01 ]);
}
