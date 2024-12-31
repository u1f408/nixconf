{ pkgs
, lib
, meta
, ...
}:

{
  imports = [
    meta.nixosModules.laptop

    ./hw.nix
  ];

  networking.hostId = "9ac732ba";
  system.stateVersion = "24.05";
}
