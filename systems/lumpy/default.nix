{ pkgs
, lib
, meta
, ...
}:

{
  imports = [
    meta.nixosModules.workstation
    ./hw.nix
  ];

  u1f408.machineClass = "laptop";

  networking.hostId = "9ac732ba";
  system.stateVersion = "24.05";
}
