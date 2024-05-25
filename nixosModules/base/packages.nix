{ pkgs
, ...
}:

{
  environment.systemPackages = with pkgs; [
    vim
    mle
    tmux
    htop
    mosh
    p7zip
    neofetch

    usbutils
    pciutils
    unstable.flashprog
  ];
}
