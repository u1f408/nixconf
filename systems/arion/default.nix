{ meta
, lib
, pkgs
, config
, ...
}:

{
  imports = [
    meta.nixosModules.prodigi
    meta.nixosModules.workstation-gnome
    meta.nixosModules.loopback-cam
    meta.nixosModules.virt

    ./hw.nix
    ./persist.nix
  ];

  u1f408.machineClass = "laptop";
  nixpkgs.config.allowUnfree = true;

  networking.hostId = "2a7ad309";
  system.stateVersion = "24.05";
}
