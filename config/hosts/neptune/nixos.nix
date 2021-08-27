{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    ./net.nix
  ];

  deploy.tf = {
    resources.neptune = {
      provider = "null";
      type = "resource";
      connection = {
        host = "root@neptune.smol.systems";
        port = 62954;
      };
    };
  };

  boot.cleanTmpDir = true;
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "c3f9bba2";
  networking.hostName = "neptune";
  networking.firewall.allowPing = true;

  system.stateVersion = "21.05";
}
