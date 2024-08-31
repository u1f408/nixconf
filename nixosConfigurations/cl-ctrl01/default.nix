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
  ];

  networking.hostId = "c1f2890b";

  iris.cluster = {
    enable = true;
    isController = true;
    datacenter = "home";
  };

  systemd.network.wait-online.enable = false;
  systemd.network.networks."eth0" = {
    matchConfig = { Name = "eth0"; };
    address = [ "10.42.162.10/16" ];
    routes = [ { routeConfig = { Gateway = "10.42.0.1"; }; } ];
    dns = [ "1.1.1.1" "1.0.0.1" ];
  };

  system.stateVersion = "24.05";
}
