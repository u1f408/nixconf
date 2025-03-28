{ pkgs
, lib
, meta
, ...
}:

{
  imports = [
    meta.nixosModules.server

    ./hw.nix
    ./networking.nix

    ./services/web.nix
    ./services/database.nix
    ./services/identity.nix
    ./services/headscale.nix
  ];

  networking.hostId = "37c5af91";
  system.stateVersion = "24.11";
}
