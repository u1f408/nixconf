{ config, lib, pkgs, ... }:

{
  imports = [
    ./lightdm.nix
    ./pipewire.nix
    ./firefox.nix
    ./fonts.nix
  ];

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvorak";
  services.xserver.xkbOptions = "caps:compose";

  fonts.fontconfig.enable = true;
}
