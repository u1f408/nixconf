{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    profiles.gui
    profiles.xfce
    users.iris.guiFull
  ];

  deploy.tf = {
    resources.pluto = {
      provider = "null";
      type = "resource";
      connection = {
        host = "root@pluto";
        port = 62954;
      };
    };
  };

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
