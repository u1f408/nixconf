{ config, lib, pkgs, ... }:

{
  imports = [ ];

  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [ hikari-session ]; 
  services.xserver.displayManager.sessionPackages = with pkgs; [ hikari-session ];

  security.pam.services.hikari-unlocker = {};
}
