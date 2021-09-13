{ wrapShellScriptBin, pkgs }:

wrapShellScriptBin "iris-ss" ./iris-ss {
  depsRuntimePath = with pkgs; [
    coreutils
    bash

    slurp
    grim
    sway
    jq

    wl-clipboard
    libnotify
  ];
}
