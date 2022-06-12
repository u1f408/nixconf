{ config, pkgs, lib ? pkgs.lib, ... }:

{
  services.nginx.virtualHosts."tools.irys.cc" = {
    enableACME = true;
    forceSSL = true;
    root = "/srv/http/tools.irys.cc/public";

    locations."~ \.php($|/)".extraConfig = ''
      fastcgi_pass unix:${config.services.phpfpm.pools.www.socket};
      fastcgi_index index.php;
    '';

    extraConfig = ''
      rewrite ^/pkavi/([msg])/(.*)(?:\.[a-z]+)?$ /pkavi.php?ty=$1&id=$2&$args last;
    '';
  };
}
