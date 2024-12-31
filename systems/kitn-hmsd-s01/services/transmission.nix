{ pkgs
, lib
, ...
}:

{
  services.transmission = {
    enable = true;
    group = "users";
    package = pkgs.transmission_4;
    webHome = pkgs.flood-for-transmission;
    credentialsFile = "/srv/mediastate/transmission-daemon.json";

    settings = {
      rpc-bind-address = "0.0.0.0";
      watch-dir-enabled = false;
      incomplete-dir-enabled = false;
      download-dir = "/srv/archive/downloads";
    };
  };
}
