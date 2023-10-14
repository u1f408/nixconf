{ config
, options
, pkgs
, lib
, ...
}:

with lib;

let
  cfg = config.iris.gui;

in
{
  options = {
    iris.gui = {
      enable = mkEnableOption "GUI configuration";
      environment = mkOption {
        type = types.enum [ "none" "gnome" ];
        default = "none";
        description = mdDoc "The desktop environment to use";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        rxvt-unicode-emoji
        dillo
      ];

      fonts = {
        fonts = with pkgs; [
          dejavu_fonts
          comic-mono
          comic-neue
          openmoji-color
        ];

        fontconfig = {
          allowBitmaps = true;
          defaultFonts.emoji = [
            "OpenMoji Color"
            "OpenMoji"
          ];
        };
      };
    }

    (mkIf (cfg.environment == "gnome") {
      services.xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      services.xserver.desktopManager.gnome = {
        enable = true;
      };
    })

    (mkIf (cfg.environment != "none" && cfg.environment != "gnome") {
      services.xserver.displayManager.lightdm = {
        enable = true;
        greeters.gtk.enable = true;
      };
    })
  ]);
}
