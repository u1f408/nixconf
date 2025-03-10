{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    python3
    element-desktop

    unstable.winbox4
    # winbox
    remotedesktopmanager
  ];
}
