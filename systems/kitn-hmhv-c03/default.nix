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
    ./networking.nix
  ];

  networking.hostId = "3ac9db8f";
  system.stateVersion = "24.05";
}
