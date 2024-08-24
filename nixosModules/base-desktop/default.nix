{ inputs
, meta
, pkgs
, lib
, ...
}:

{
  imports = [
    ./packages.nix
    ./networking.nix
    ./display-manager.nix
  ];

  time.timeZone = lib.mkDefault "Pacific/Auckland";
  security.sudo.wheelNeedsPassword = false;

  security.rtkit.enable = true;
  services.irqbalance.enable = true;
  services.xserver.enable = true;
  hardware.opengl.enable = true;
  fonts.enableDefaultPackages = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    wireplumber = {
      enable = true;
    };
  };
}
