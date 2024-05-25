{ inputs
, meta
, pkgs
, lib
, ...
}:

{
  imports = [
    meta.nixosModules.base-users

    ./networking.nix
    ./lightdm.nix
  ];

  time.timeZone = lib.mkDefault "Pacific/Auckland";
  security.sudo.wheelNeedsPassword = false;

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

  environment.systemPackages = with pkgs; [
    pavucontrol

    firefox
    remmina
    xpra
  ];
}
