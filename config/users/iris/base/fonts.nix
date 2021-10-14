{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    dejavu_fonts
    hack-font
    comic-code
    tewi-font
    open-dyslexic
  ];
}
