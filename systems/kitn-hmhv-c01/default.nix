{ pkgs
, lib
, meta
, ...
}:

{
  imports = [
    meta.nixosModules.server
    meta.nixosModules.virt

    ./hw.nix
    ./storage.nix
    ./networking.nix
  ];

  networking.hostId = "3ac98cfa";
  system.stateVersion = "24.05";
}
