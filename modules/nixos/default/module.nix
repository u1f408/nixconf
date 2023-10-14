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
      defaultSystemPackages = mkEnableOption (mdDoc "default system package set");
    };
  };

  config = {
    environment.systemPackages = mkIf cfg.defaultSystemPackages (with pkgs; [
      bc
      mle
      ksh
      tmux
      htop
      minicom
    ]);
  };
}
