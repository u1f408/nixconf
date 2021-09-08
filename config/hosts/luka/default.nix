{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    profiles.dev
    profiles.gui
    profiles.sway
    users.iris.guiFull
    users.iris.workstation
    users.iris.dev
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.initrd.supportedFilesystems = [ "zfs" "vfat" ];
  boot.supportedFilesystems = [ "zfs" "vfat" ];
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "4b289aa2";
  networking.hostName = "luka";
  networking.useDHCP = false;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  system.stateVersion = "21.05";
}
