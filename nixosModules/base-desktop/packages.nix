{ pkgs
, ...
}:

{
  environment.systemPackages = with pkgs; [
    pavucontrol
    papers
    mupdf

    firefox
    chromium

    remmina
    xpra
  ];
}