{ pkgs
, lib
, inputs
, system
, ...
}:

{
  imports = [
    ./hw.nix
  ];

  iris = {
    enabledUsers = [ "iris" ];
    defaultSystemPackages = true;

    gui = {
      enable = true;
      environment = "gnome";
    };
  };


  networking = {
    hostName = "hydrochaeris";
    hostId = "a77c3b92";
    useDHCP = false;
    networkmanager = {
      enable = true;
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  time.timeZone = "Pacific/Auckland";
  security.sudo.wheelNeedsPassword = false;
  systemd.network.wait-online.enable = false;
  system.stateVersion = "23.05";
}
