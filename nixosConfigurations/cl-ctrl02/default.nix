{ meta
, lib
, pkgs
, ...
}:

{
  imports = [
    meta.nixosModules.base-server
    meta.nixosModules.cluster

    ./hw.nix
    ./persist.nix
  ];

  networking.hostId = "c101ce43";

  iris.cluster = {
    enable = true;
    datacenter = "home";
    isController = true;
  };

  systemd.network.wait-online.enable = false;
  systemd.network.networks."eth0" = {
    matchConfig = { Name = "eth0"; };
    address = [ "10.42.162.11/16" ];
    routes = [ { routeConfig = { Gateway = "10.42.0.1"; }; } ];
    dns = [ "1.1.1.1" "1.0.0.1" ];
  };

  system.stateVersion = "24.05";
}
