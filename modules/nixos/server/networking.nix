{ pkgs
, lib
, ...
}:

{

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.useDHCP = lib.mkForce false;
  systemd.network.enable = true;

  services.networkd-dispatcher = {
    enable = true;
    rules = {
      "udp-gro-forwarding" = {
        onState = [ "routable" ];
        script = ''
          #! ${pkgs.runtimeShell}
          netdev=`${pkgs.iproute2}/bin/ip -o route get 8.8.8.8 | cut -f 5 -d ' '`
          ${pkgs.ethtool}/bin/ethtool -K $netdev rx-udp-gro-forwarding on rx-gro-list off
        '';
      };

      "ipoib-connected" = {
        onState = [ "configuring" ];
        script = ''
          #! ${pkgs.runtimeShell}
          test -d "/sys/class/net/$IFACE/device/infiniband" || exit
          echo connected > "/sys/class/net/$IFACE/mode"
          ${pkgs.iproute2}/bin/ip -o link set mtu 65520 dev "$IFACE"
        '';
      };
    };
  };

  services.tailscale.extraUpFlags = [ "--ssh" ];
}