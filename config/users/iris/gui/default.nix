{ pkgs, lib, meta, ... }:

{
  imports = [
    ./firefox
    ./alacritty.nix
    ./packages.nix
  ];

  home.packages = with pkgs; [
    pavucontrol

    xfce.thunar
    xfce.thunar-volman
    xfce.xfconf
    xfce.tumbler
    xfce.exo
  ];
}
