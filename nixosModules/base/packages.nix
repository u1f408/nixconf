{ config
, pkgs
, lib
, ...
}:

with lib;
let
  cfg = config.iris;

in
{
  options.iris = {
    useDefaultPackages = mkEnableOption "default package set" // { default = true; }; 
  };

  config = mkIf cfg.useDefaultPackages {
    environment.systemPackages = with pkgs; [
      iris-scripts

      git
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

      libarchive
    ];
  };
}
