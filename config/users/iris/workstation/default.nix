{ config, pkgs, lib, ... }:

{
  imports = [ ];

  home.packages = with pkgs; [
    sublime4
    sublime-merge

    gajim
    mumble

    wineWowPackages.stable
  ];
}
