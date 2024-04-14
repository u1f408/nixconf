{ config
, pkgs
, lib
, ...
}:

{
  services.nginx = {
    enable = true;

    virtualHosts."soupnet.cc" = {
      forceSSL = true;
      enableACME = true;

      locations."= /.well-known/webfinger".extraConfig = ''
        if ($request_method !~ ^(GET|HEAD)$) { return 405; }
        set_by_lua $resource 'return ngx.unescape_uri(ngx.req.get_uri_args()["resource"])';
        if ($resource ~ (?:acct\:)?([A-Za-z]+)@soupnet.cc$) { set $user $1; rewrite .* /webfinger/$user.json last; }
        return 400;
      '';

      locations."~ ^/webfinger/[A-Za-z]+.json$".extraConfig = ''
        types { } default_type 'application/jrd+json';
        add_header 'Access-Control-Allow-Origin' '*';
        root /var/www/soupnet.cc/public;
      '';

      locations."/".root = "/var/www/soupnet.cc/public";
    };

    virtualHosts."auth.soupnet.cc" = {
      forceSSL = true;
      enableACME = true;
      locations."= /".extraConfig = "return 302 '/realms/soupnet/account';";
      locations."/".proxyPass = "http://127.0.0.1:${builtins.toString config.services.keycloak.settings.http-port}";
    };
  };
}
