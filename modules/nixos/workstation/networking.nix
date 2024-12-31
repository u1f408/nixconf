{ pkgs
, lib
, ...
}:

{
  networking.useDHCP = lib.mkForce false;
  services.tailscale.extraUpFlags = [ "--accept-routes" ];

  networking.networkmanager = {
    enable = true;
  };
}
