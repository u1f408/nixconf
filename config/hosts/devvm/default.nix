{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    profiles.dev
    profiles.gui
    profiles.headlessgui
    profiles.awesomewm
    users.iris.guiFull
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "c3ba22f7";
  networking.hostName = "devvm";
  networking.useDHCP = false;
  networking.interfaces.ens192.useDHCP = false;

  system.stateVersion = "21.05";
}
