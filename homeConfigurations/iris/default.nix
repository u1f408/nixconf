{ inputs
, pkgs
, ...
}:

{
  imports = [
    ./fonts.nix
    ./packages.nix
    ./dotcfg.nix
  ];

  home.stateVersion = "23.11";
}
