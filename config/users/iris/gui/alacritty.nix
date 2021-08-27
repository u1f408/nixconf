{ config, pkgs, lib, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = config.kw.font.size;
        normal.family = config.kw.font.name;
      };
    };
  };
}
