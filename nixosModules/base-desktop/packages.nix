{ pkgs
, ...
}:

{
  iris.allowUnfreePackages = [ "zoom" "zoom-us" ];

  environment.systemPackages = with pkgs; [
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