{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    ./net.nix
    profiles.common
    services.nginx
    services.jellyfin
  ];

  boot.cleanTmpDir = true;
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "c3f9bba2";
  networking.hostName = "neptune";
  networking.firewall.allowPing = true;

  system.stateVersion = "21.05";
}
