{ inputs
, meta
, ...
}:

{
  imports = [
    meta.nixosModules.base-server

    ./hw.nix
    ./services/postgres.nix
    ./services/redis.nix
  ];

  networking.hostId = "e4ca38e2";

  networking.firewall.trustedInterfaces = [ "eth0" ];
  systemd.network.networks."eth0" = {
    matchConfig = { Name = "eth0"; };
    address = [ "10.42.55.2/16" ];
    gateway = [ "10.42.0.1" ];
  };

  system.stateVersion = "23.11";
}
