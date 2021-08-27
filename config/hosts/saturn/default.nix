{ config, sources, pkgs, lib, meta, ... }:

with lib;

{
  imports = with meta; [
    ./hw.nix
    services.nginx
    services.matrix
  ];

  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostId = "d39a77fb";
  networking.hostName = "saturn";
  networking.domain = "smol.systems";

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  system.stateVersion = "21.05";
}
