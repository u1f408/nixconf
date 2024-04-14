{ inputs
, meta
, ...
}:

{
  imports = [
    meta.nixosModules.users
    meta.nixosModules.server

    ./hw.nix
    ./services/nginx.nix
    ./services/postgresql.nix
    ./services/lldap.nix
    ./services/keycloak.nix
  ];

  networking.hostId = "ba932a71";
  systemd.network.networks."eth0" = {
    matchConfig = { Name = "eth0"; };
    address = [ "37.27.38.10/32" ];
    routes = [
      { routeConfig = { Destination = "172.31.1.1/32"; }; }
      { routeConfig = { Gateway = "172.31.1.1"; }; }
    ];
  };

  system.stateVersion = "23.11";
}
