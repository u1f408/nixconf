{ pkgs
, lib
, ...
}:

{
  hardware.infiniband = {
    enable = true;
    guids = [ "0xe0071bffff6f7f11" "0xe0071bffff6f7f12" ];
  };

  systemd.network = {
    netdevs = {
      "10-bond0" = {
        netdevConfig = {
          Kind = "bond";
          Name = "bond0";        
        };

        bondConfig = {
          Mode = "active-backup";
          PrimaryReselectPolicy = "always";
          MIIMonitorSec = "1s";
        };
      };

      "10-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };
    };

    networks = {
      "10-ib0" = {
        matchConfig.Name = "ib0";
        address = [ "10.57.253.33/24" ];
      };

      "10-eth0" = {
        matchConfig.Name = "eth0";
        networkConfig.Bond = "bond0";
      };

      "10-eth1" = {
        matchConfig.Name = "eth1";
        networkConfig.Bond = "bond0";
      };

      "20-bond0" = {
        matchConfig.Name = "bond0";
        networkConfig.Bridge = "br0";
      };

      "30-br0" = {
        matchConfig.Name = "br0";
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = false;
        };
      };
    };
  };
}