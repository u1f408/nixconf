{ inputs
, pkgs
, lib
, ...
}:

{
  imports = [
    ./git.nix
  ];

  home.packages = with pkgs; [
    figlet
  ];
}
