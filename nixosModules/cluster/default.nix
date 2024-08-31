{ config
, pkgs
, lib
, ...
}:

with lib;
{
  options.iris.cluster = {
    enable = mkEnableOption "cluster service configuration" // { default = false; };

    datacenter = mkOption {
      type = types.str;
      description = ''
        Datacenter name for this cluster
      '';
    };

    isController = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether this node should run the cluster controller services
      '';
    };
  };

  imports = [
    ./consul.nix
    ./vault.nix
    ./nomad.nix
  ];
}
