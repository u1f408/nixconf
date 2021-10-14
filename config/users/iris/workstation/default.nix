{ config, pkgs, lib, ... }:

{
  imports = [ ];

  home.packages = with pkgs; [
    sublime4
    sublime-merge

    gajim
    mumble
    hexchat
    
    aseprite-unfree
    wineWowPackages.stable
    winetricks

    icewm-xephyr
  ];
}
