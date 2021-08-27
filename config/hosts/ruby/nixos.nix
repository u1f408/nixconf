{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    profiles.dev
    profiles.gui
    profiles.hikari
    users.iris.guiFull
    users.iris.dev
  ];

  deploy.tf = {
    resources.ruby = {
      provider = "null";
      type = "resource";
      connection = {
        host = "root@ruby";
        port = 62954;
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.supportedFilesystems = [ "zfs" "vfat" ];
  boot.supportedFilesystems = [ "zfs" "vfat" ];
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "ac3f29ba";
  networking.hostName = "ruby";
  networking.useDHCP = false;
  networking.interfaces.mlan0.useDHCP = false;

  services.logind.extraConfig = ''
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    HandleLidSwitch=ignore
  '';

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  system.stateVersion = "21.05";
}
