{ config, pkgs, ... }:

{
  imports = [
    ./waybar.nix
    ./wofi.nix
    ./sway.nix
    ./packages.nix
  ];
}
