{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    profiles.gui
    profiles.xfce
    users.iris.guiFull
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "c3ba97f2";
  networking.hostName = "pluto";
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = false;

  system.stateVersion = "21.05";
}
