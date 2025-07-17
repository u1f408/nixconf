{ systemConfig
, pkgs
, lib
, ...
}:

let
  inherit (systemConfig.u1f408) machineClass machineUsage;
in
{
  home.packages = lib.mkMerge [
    (with pkgs; [
      jq
      mle
      fzf
      tmux
    ])

    (lib.mkIf (with lib; any (f: hasPrefix "gui-" f) machineUsage) (with pkgs; [
      roxterm
      remmina
      bitwarden
    ]))
  ];
}
