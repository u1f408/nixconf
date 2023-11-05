{ inputs
, pkgs
, lib
, ...
}:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    figlet
    remmina
    foliate
  ];
}
