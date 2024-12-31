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

  boot.zfs.extraPools = [
    "z_79f228"
  ];

  networking.hostId = "3ac9db8f";
  system.stateVersion = "24.05";
}
