{ config
, pkgs
, lib
, ...
}:

{
  networking.firewall.allowedTCPPorts = lib.mkIf config.services.nginx.enable [ 80 443 ];
  services.nginx = {
    package = pkgs.openresty;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
  };
}
