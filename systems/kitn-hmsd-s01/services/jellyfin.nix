{ lib
, ...
}:

{
  virtualisation.oci-containers.containers = {
    "jellyfin" = {
      image = "docker.io/jellyfin/jellyfin";
      environmentFiles = [ "/srv/mediastate/jellyfin.env" ];
      volumes = [
        "/srv/mediastate/jellyfin-config:/config"
        "/srv/mediastate/jellyfin-cache:/cache"
        "/srv/archive/media:/media"
      ];
    };

    "jellyfin-tsnsrv" = {
      image = "ghcr.io/boinkor-net/tsnsrv:latest";
      dependsOn = [ "jellyfin" ];
      extraOptions = [ "--link=jellyfin" ];
      environmentFiles = [ "/srv/mediastate/jellyfin-tsnsrv.env" ];
      volumes = [
        "/srv/mediastate/jellyfin-tsnsrv:/config"
      ];

      cmd = [
        "-name" "jellyfin"
        "-stateDir" "/config/state"
        "-authkeyPath" "/config/ts-authkey"
        "-funnel=true"
        "-suppressTailnetDialer=true"
        "http://jellyfin:8096"
      ];
    };
  };
}
