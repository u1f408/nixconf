{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g default-terminal 'screen-256color'
      set -ga terminal-overrides ',screen-256color:Tc'
    '';

    baseIndex = 1;
    reverseSplit = true;
  };
}
