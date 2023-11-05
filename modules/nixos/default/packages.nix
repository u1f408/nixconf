{ config
, options
, pkgs
, lib
, ...
}:

with lib;

let
  cfg = config.iris;

in
{
  options = {
    iris = {
      defaultSystemPackages = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc "Enable default system package set";
      };
    };
  };

  config = {
    environment.systemPackages = mkIf cfg.defaultSystemPackages (with pkgs; [
      bc
      mle
      ksh
      tmux
      htop
      mosh
      minicom
    ]);
  };
}
