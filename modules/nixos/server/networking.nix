{ pkgs
, lib
, ...
}:

{

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  systemd.network.enable = true;
  networking.useDHCP = lib.mkForce false;

  services.tailscale.extraUpFlags = [ "--ssh" ];
}