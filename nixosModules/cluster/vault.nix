{ config
, pkgs
, lib
, std
, ...
}:

with lib;
let
  cfg = config.iris.cluster;
  enableVault = cfg.enable && cfg.isController;

in
{
  config = {
    iris.allowUnfreePackages = optionals cfg.enable [ "vault-bin" ];
    environment.systemPackages = optionals cfg.enable (with pkgs; [
      vault-bin
    ]);

    services.vault = mkIf enableVault {
      enable = true;
      package = pkgs.vault-bin;
      address = "{{ GetInterfaceIP \\\"tailscale0\\\" }}:8200";

      storageBackend = "consul";
      storageConfig = ''
        address = "unix:///run/consul-${cfg.datacenter}-http.sock"
      '';

      extraConfig = ''
        ui = true
      '';
    };
  };
}
