{ meta, inputs, pkgs, lib ? pkgs.lib, ... }:

{
  imports = with meta; [
    ./hw.nix
    profiles.server

    services.phpfpm
    services.nginx
    ./nginx
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  boot.supportedFilesystems = [ "zfs" "vfat" ];
  boot.zfs.devNodes = "/dev/";

  networking.hostName = "yellow";
  networking.domain = lib.mkForce "sleepi.cc";
  networking.hostId = "ef8426e0";
  networking.useDHCP = lib.mkForce true;

  services.zfs.trim.enable = true;
  services.zfs.autoScrub = {
    enable = true;
    pools = [ "rpool" ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  system.stateVersion = "22.05";
}
