{ inputs, meta, pkgs, lib ? pkgs.lib, ... }:

{
  services.tailscale = {
    enable = true;
    interfaceName = "tailscale0";
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
