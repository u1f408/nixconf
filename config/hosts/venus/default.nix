{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    services.nginx
  ];

  nixpkgs.localSystem = systems.examples.aarch64-multiplatform // {
    system = "aarch64-linux";
  };

  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "8b29fcab";
  networking.hostName = "venus";
  networking.domain = "smol.systems";

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  system.stateVersion = "21.05";
}
