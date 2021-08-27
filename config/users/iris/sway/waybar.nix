{ config, lib, pkgs, ... }:

let
  base16 = config.kw.hexColors;
in
{
  programs.waybar = {
    enable = true;

    style = import ./waybar.css.nix {
      inherit base16;
      inherit (lib) hextorgba;
      font = config.kw.font;
    };

    settings = [{
      modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
      modules-center = [ "clock" "clock#tavy" "clock#kat" "clock#storybook" ];
      modules-right = [
        "pulseaudio"
        "battery"
        "network"
        "idle_inhibitor"
        "tray"
      ];

      modules = {
        "sway/workspaces" = { format = "{name}"; };
        "sway/window" = {
          format = " {}";
          max-length = 50;
        };
        tray = {
          icon-size = 12;
          spacing = 2;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        battery = {
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [ "" "" "" "" "" ];
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "婢";
          on-click = "foot pulsemixer";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
        };
        network = {
          format-wifi = "直";
          format-ethernet = "";
          format-linked = " {ifname} (NO IP)";
          format-disconnected = " DC";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
        };
        clock = {
          format = "{:%a, %F %T}";
          tooltip = true;
          tooltip-format = "{:%A, %F %T %z (%Z)}";
          timezones = [
            "Pacific/Auckland"
            "America/Los_Angeles"
            "Europe/London"
            "America/New_York"
          ];
          interval = 1;
        };
        "clock#tavy" = {
          format = "♥-{:%H}";
          tooltip = true;
          timezone = "America/Los_Angeles";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
        "clock#kat" = {
          format = "♥-{:%H}";
          tooltip = true;
          timezone = "Europe/London";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
        "clock#storybook" = {
          format = "♥-{:%H}";
          tooltip = true;
          timezone = "America/New_York";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
      };
    }];
  };
}
