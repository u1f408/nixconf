{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    python3
    element-desktop
    remotedesktopmanager
  ];
}
