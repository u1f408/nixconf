{ inputs
, meta
, ...
}:

{
  imports = [
    meta.nixosModules.desktop
    ./hw.nix
  ];

  networking.hostId = "c6eb782a";
  system.stateVersion = "23.11";
}
