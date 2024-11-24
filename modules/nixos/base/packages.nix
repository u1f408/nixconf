{ pkgs
, lib
, ...
}:

{
  environment.systemPackages = with pkgs; [
    tmux
    htop
    mosh
    hyfetch
    fastfetch
    libarchive

    git
    vim
    mle
    nano

    usbutils
    pciutils
  ];
}
