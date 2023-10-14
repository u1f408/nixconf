{ inputs
, pkgs
, lib
, ...
}:

{
  imports = [
    ./shell.nix
    ./git.nix
  ];

  home.packages = with pkgs; [
    figlet
  ];
}
