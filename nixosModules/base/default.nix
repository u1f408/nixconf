{ inputs
, pkgs
, lib
, ...
}:

{
  imports = [
    ./users
    ./home-manager.nix
    ./networking.nix
    ./agenix.nix
    ./misc.nix
    ./nix.nix
    ./packages.nix
  ];
}
