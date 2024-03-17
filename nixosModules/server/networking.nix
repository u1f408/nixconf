{ pkgs
, lib
, ...
}:

{
  networking.useDHCP = false;
  systemd.network.enable = true;
  services.tailscale.extraUpFlags = [ "--ssh" ];
}
