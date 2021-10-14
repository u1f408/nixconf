{ pkgs, lib ? pkgs.lib, wrapShellScriptBin, makeDesktopItem }:

let
  script = wrapShellScriptBin "icewm-xephyr" ./icewm-xephyr.sh {
    depsRuntimePath = with pkgs; [
      coreutils
      bash

      icewm
      xorg.xorgserver
    ];
  };

  desktop = makeDesktopItem {
    name = "icewm-xephyr";
    exec = "${script}/bin/icewm-xephyr";
    desktopName = "IceWM (in Xephyr)";
  };

in desktop
