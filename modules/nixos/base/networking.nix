{ pkgs
, lib
, ...
}:

{
  networking.usePredictableInterfaceNames = false;
  networking.nftables.enable = true;
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };

  services.tailscale.enable = true;
  services.resolved = {
    enable = true;
    llmnr = "resolve";
    fallbackDns = [ "1.1.1.1" "1.0.0.1" ];
  };
}
