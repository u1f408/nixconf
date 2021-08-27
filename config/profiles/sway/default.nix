{ config, lib, pkgs, ... }:

{
  imports = [ ];

  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [ sway ]; 
  services.xserver.displayManager.sessionPackages = with pkgs; [ sway ];
  
  security.pam.services.swaylock = {};
}
