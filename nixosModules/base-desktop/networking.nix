{ pkgs
, lib
, ...
}:

{
  networking.useDHCP = false;
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    wifi.backend = "iwd";
  };

  services.avahi.enable = true;
}
