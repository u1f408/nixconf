{ lib
, ...
}:

{
  virtualisation.oci-containers.containers = {
    "miniflux-db" = {
      image = "docker.io/postgres:15";
      environmentFiles = [ "/srv/mediastate/miniflux-db.env" ];
      volumes = [
        "/srv/mediastate/miniflux-db:/var/lib/postgresql/data"
      ];
    };

    "miniflux" = {
      image = "docker.io/miniflux/miniflux:latest";
      dependsOn = [ "miniflux-db" ];
      extraOptions = [ "--link=miniflux-db" ];
      environmentFiles = [ "/srv/mediastate/miniflux.env" ];
    };

    "miniflux-tsnsrv" = {
      image = "ghcr.io/boinkor-net/tsnsrv:latest";
      dependsOn = [ "miniflux" ];
      extraOptions = [ "--link=miniflux" ];
      environmentFiles = [ "/srv/mediastate/miniflux-tsnsrv.env" ];
      volumes = [
        "/srv/mediastate/miniflux-tsnsrv:/config"
      ];

      cmd = [
        "-name" "miniflux"
        "-stateDir" "/config/state"
        "-authkeyPath" "/config/ts-authkey"
        "-suppressTailnetDialer=true"
        "http://miniflux:8080"
      ];
    };
  };
}
