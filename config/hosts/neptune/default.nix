{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    ./net.nix
    profiles.common
  ];

  boot.cleanTmpDir = true;
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "c3f9bba2";
  networking.hostName = "neptune";
  networking.firewall.allowPing = true;

  system.stateVersion = "21.05";
}
