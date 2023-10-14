{ inputs
, pkgs
, lib
, ...
}:

let
  adminGroups = [ "wheel" "systemd-journal" ];

in rec {
  iris = {
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.ksh;
    useDefaultShell = false;
    extraGroups = adminGroups ++ [ ];
    hashedPassword = "$y$j9T$lM8YpVHfRx4MX4/fsuZIq.$k2kmD/rKDYxrxqtEL/WZXo2zYsutuNRo.4cDJtL0h87";
  };
}
