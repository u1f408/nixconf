{ pkgs
, lib
, ...
}:

{
  systemd.network = {
    networks = {
      "10-eth0" = {
        matchConfig.Name = "eth0";

        address = [ "23.94.235.15/26" ];
        routes = [ { Gateway = "23.94.235.1"; } ];

        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
