{ pkgs
, lib
, ...
}:

{
  environment.systemPackages = with pkgs; [
    xclip
    xorg.xrandr
    xorg.xrdb
    xdgmenumaker
    windowmaker
    apple-cursor
  ];

  services.xserver.enable = lib.mkForce false;
  services.displayManager.enable = lib.mkForce false;
  services.displayManager.sddm.enable = lib.mkForce false;
  services.pulseaudio.enable = lib.mkForce true;
  services.pipewire.enable = lib.mkForce false;

  services.xrdp = {
    enable = true;
    openFirewall = true;
    audio.enable = true;

    defaultWindowManager = "wmaker";

    sslCert = "/persist/etc/xrdp/cert.pem";
    sslKey = "/persist/etc/xrdp/key.pem";
  };
}
