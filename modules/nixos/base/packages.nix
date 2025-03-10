{ pkgs
, lib
, ...
}:

{
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    file
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
