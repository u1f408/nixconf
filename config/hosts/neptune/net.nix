{ lib, ... }:

{
  networking = {
    networkmanager.enable = lib.mkForce false;
    dhcpcd.enable = lib.mkForce false;

    defaultGateway = "137.184.0.1";
    defaultGateway6 = "2604:a880:4:1d0::1";
    usePredictableInterfaceNames = lib.mkForce false;

    interfaces = {
      eth0 = {
        ipv4.routes = [ { address = "137.184.0.1"; prefixLength = 32; } ];
        ipv4.addresses = [
          { address="137.184.0.53"; prefixLength=20; }
          { address="10.48.0.6"; prefixLength=16; }
        ];
        
        ipv6.routes = [ { address = "2604:a880:4:1d0::1"; prefixLength = 128; } ];
        ipv6.addresses = [
          { address="2604:a880:4:1d0::362:0"; prefixLength=64; }
          { address="fe80::d00f:24ff:fe8b:d3a5"; prefixLength=64; }
        ]; 
      };
    };
  };
  
  services.udev.extraRules = ''
    ATTR{address}=="d2:0f:24:8b:d3:a5", NAME="eth0"
    ATTR{address}=="ce:84:07:7b:d0:59", NAME="eth1"
  '';
}
