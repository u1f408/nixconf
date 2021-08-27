{ config, lib, pkgs, meta, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };

  security.acme = {
    email = "iris@iris.ac.nz";
    acceptTerms = true;
  };
}
