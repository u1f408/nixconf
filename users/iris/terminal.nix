{ systemConfig
, pkgs
, lib
, ...
}:

let
  inherit (systemConfig.u1f408) machineClass machineUsage;
  shouldUse = with lib; any (f: hasPrefix "gui-" f) machineUsage;

in
{
  config = lib.mkIf shouldUse {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      themeFile = "Catppuccin-Latte";

      font.name = "M+1Code Nerd Font Light";
      font.size = 12;

      extraConfig = ''
        kitty_mod ctrl+alt
      '';
    };
  };
}
