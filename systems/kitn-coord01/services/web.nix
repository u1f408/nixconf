{ config
, meta
, pkgs
, lib
, ...
}:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy.enable = true;

  services.caddy.virtualHosts."soupnet.cc" = {
    extraConfig = ''
      @webfingerOIDC {
        path /.well-known/webfinger
        method GET HEAD
        query rel=http://openid.net/specs/connect/1.0/issuer
      }

      handle @webfingerOIDC {
        templates {
          mime application/jrd+json
        }

        header {
          Content-Type application/jrd+json
          Access-Control-Allow-Origin *
          X-Robots-Tag noindex
        }

        respond <<JSON
        {
          "subject": "{{ placeholder "http.request.uri.query.resource" }}",
          "links": [
            {
              "rel": "http://openid.net/specs/connect/1.0/issuer",
              "href": "https://idm.soupnet.cc"
            }
          ]
        }
        JSON 200
      }

      handle {
        respond 404
      }
    '';
  };
}
