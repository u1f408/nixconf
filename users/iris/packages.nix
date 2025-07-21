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
      flow-control
      inetutils
      dnsutils
      usbutils
    ])

    (lib.mkIf (with lib; any (f: hasPrefix "gui-" f) machineUsage) (with pkgs; [
      kitty
      remmina
      bitwarden
      galculator
    ]))

    (lib.mkIf (with lib; any (f: f == "gui-local") machineUsage) (with pkgs; [
      parsec-bin
    ]))
  ];
}
