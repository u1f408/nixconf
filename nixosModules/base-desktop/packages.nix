{ pkgs
, ...
}:

{
  iris.allowUnfreePackages = [ "zoom" "zoom-us" "winbox" ];

  environment.systemPackages = with pkgs; [
    winbox4

    pavucontrol
    papers
    mupdf

    firefox
    chromium
    zoom-us

    remmina
    xpra
  ];
}