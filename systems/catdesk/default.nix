{ config
, meta
, lib
, pkgs
, ...
}:

{
  imports = [
    meta.nixosModules.workstation

    ./hw.nix
    ./persist.nix
    ./xrdp.nix
  ];

  u1f408 = {
    machineClass = "server";
    machineUsage = [ "gui-xrdp" ];
  };

  services.openssh.openFirewall = true;
  system.stateVersion = "25.05";
}
