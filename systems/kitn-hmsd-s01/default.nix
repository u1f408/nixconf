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

    ./services/miniflux.nix
    ./services/jellyfin.nix
    ./services/transmission.nix
  ];

  networking.hostId = "3ac6efa3";
  system.stateVersion = "24.05";
}
