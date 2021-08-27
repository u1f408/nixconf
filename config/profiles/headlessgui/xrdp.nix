{ config, lib, pkgs, ... }:

{
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.awesome}/bin/awesome";
  networking.firewall.allowedTCPPorts = [ 3389 ];
}
