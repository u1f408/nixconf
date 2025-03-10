{ pkgs
, lib
, meta
, ...
}:

{
  imports = [
    meta.nixosModules.hw-laptop
    meta.nixosModules.workstation

    ./hw.nix
  ];

  networking.hostId = "9ac732ba";
  system.stateVersion = "24.05";
}
