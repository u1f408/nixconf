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
    sublime4
    sublime-merge

    unstable.lorien
  ];
}
