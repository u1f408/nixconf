{ meta
, lib
, pkgs
, ...
}:

{
  imports = [
    meta.nixosModules.base-desktop
    meta.nixosModules.xfce
    meta.nixosModules.labwc

    ./hw.nix
    ./persist.nix
  ];

  iris.allowUnfreePackages = [
    "steam"
    "steam-original"
  ];

  environment.systemPackages = with pkgs; [
    obs-studio
    gamescope
    steam-small
  ];

  networking.hostId = "3b1de72e";
  system.stateVersion = "24.05";
}
