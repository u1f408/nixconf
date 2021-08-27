{ config, pkgs, lib, ... }:

let
  lockCommand =
    let
      base16 = lib.mapAttrs' (k: v: lib.nameValuePair k (lib.removePrefix "#" v))
        config.kw.hexColors;

    in ''
      ${pkgs.swaylock-effects}/bin/swaylock \
        --screenshots \
        --indicator \
        --indicator-radius 110 \
        --indicator-thickness 8 \
        --clock --timestr '%H:%M:%S' --datestr '%Y-%m-%d' \
        --effect-scale 0.5 \
        --effect-vignette 0.5:0.5 \
        --effect-blur 12x4 \
        --effect-scale 2 \
        --fade-in 0.2 \
        --key-hl-color ${base16.base0C} \
        --separator-color ${base16.base01} \
        --line-color ${base16.base01} \
        --line-clear-color ${base16.base01} \
        --line-caps-lock-color ${base16.base01} \
        --line-ver-color ${base16.base01} \
        --line-wrong-color ${base16.base01} \
        --ring-color ${base16.base00} \
        --ring-clear-color ${base16.base0B} \
        --ring-caps-lock-color ${base16.base09} \
        --ring-ver-color ${base16.base0D} \
        --ring-wrong-color ${base16.base08} \
        --inside-color ${base16.base00} \
        --inside-clear-color ${base16.base00} \
        --inside-caps-lock-color ${base16.base00} \
        --inside-ver-color ${base16.base00} \
        --inside-wrong-color ${base16.base00} \
        --text-color ${base16.base05} \
        --text-clear-color ${base16.base05} \
        --text-caps-lock-color ${base16.base05} \
        --text-ver-color ${base16.base05} \
        --text-wrong-color ${base16.base05} \
    '';

  lockCommandSystemd = lib.replaceStrings ["%"] ["%%"] lockCommand; 

in
{
  home.sessionVariables = {
    WLR_DRM_DEVICES = "/dev/dri/card0";
  };

  home.packages = with pkgs; [
    grim
    slurp
    swaylock-effects
    wl-clipboard
    jq
    wofi
    wmctrl
  ];

  systemd.user.services.swayidle = {
    Unit = {
      Description = "swayidle";
      Documentation = [ "man:swayidle(1)" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w \
        timeout 300 '${lockCommandSystemd}' \
        timeout 600 'swaymsg "output * dpms off"' \
          resume 'swaymsg "output * dpms on"' \
        before-sleep '${lockCommandSystemd}'
      '';
      RestartSec = 3;
      Restart = "always";
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
  };

  wayland.windowManager.sway =
    let
      cfg = config.wayland.windowManager.sway.config;
      bindsym = k: v: "bindsym ${k} ${v}";
      bindWorkspace = key: workspace: {
        "${cfg.modifier}+${key}" = "workspace number ${workspace}";
        "${cfg.modifier}+shift+${key}" = "move container to workspace number ${workspace}";
      };
      workspaceBindings = map (v: bindWorkspace v "${v}:${v}") [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
      ]
      ++ [ (bindWorkspace "0" "10:10") ]
      ++ lib.imap1 (i: v: bindWorkspace v "${toString (10 + i)}:${v}") [
        "F1"
        "F2"
        "F3"
        "F4"
        "F5"
        "F6"
        "F7"
        "F8"
        "F9"
        "F10"
        "F11"
        "F12"
      ];
      workspaceBindings' = map (lib.mapAttrsToList bindsym) workspaceBindings;
      workspaceBindingsStr = lib.concatStringsSep "\n" (lib.flatten workspaceBindings');
    in
    {
      enable = true;
      config =
        let
          pactl = "${config.home.nixosConfig.hardware.pulseaudio.package or pkgs.pulseaudio}/bin/pactl";
          dmenu = "${pkgs.wofi}/bin/wofi -idbt ${pkgs.alacritty}/bin/alacritty -s ~/.config/wofi/wofi.css -p '' -W 25%";
        in
        {
          modes = {
            "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown" =
              {
                "l" = "exec ${lockCommand}, mode default";
                "e" = "exec swaymsg exit, mode default";
                "s" = "exec systemctl suspend, mode default";
                "h" = "exec systemctl hibernate, mode default";
                "r" = "exec systemctl reboot, mode default";
                "Shift+s" = "exec systemctl shutdown, mode default";
                "Return" = "mode default";
                "Escape" = "mode default";
              };
          };

          bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

          input = {
            "*" = {
              xkb_layout = "us";
	      xkb_variant = "dvorak";
              xkb_options = "compose:caps";
            };
          };

          fonts = {
            names = [ config.kw.font.name ];
            style = "Medium";
            size = config.kw.font.size;
          };
          
          terminal = "${pkgs.alacritty}/bin/alacritty";
          menu = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --no-generic --dmenu=\"${dmenu}\" --term='${pkgs.alacritty}/bin/alacritty'";
          modifier = "Mod4";

          startup = [
          ];

          modes.resize = {
            "a" = "resize shrink width 4 px or 4 ppt";
            "s" = "resize shrink height 4 px or 4 ppt";
            "w" = "resize grow height 4 px or 4 ppt";
            "d" = "resize grow width 4 px or 4 ppt";
            "Left" = "resize shrink width 4 px or 4 ppt";
            "Down" = "resize shrink height 4 px or 4 ppt";
            "Up" = "resize grow height 4 px or 4 ppt";
            "Right" = "resize grow width 4 px or 4 ppt";
            Return = ''mode "default"'';
            Escape = ''mode "default"'';
            "${cfg.modifier}+z" = ''mode "default"'';
          };

          window = {
            border = 1;
            titlebar = false;
          };

          floating = {
            border = 1;
            titlebar = false;
          };

          keybindings = {
            "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
            "${cfg.modifier}+x" = "exec ${lockCommand}";

            # focus windows - regular
            "${cfg.modifier}+Left" = "focus left";
            "${cfg.modifier}+Down" = "focus down";
            "${cfg.modifier}+Up" = "focus up";
            "${cfg.modifier}+Right" = "focus right";

            # move window / container - regular
            "${cfg.modifier}+Shift+Left" = "move left";
            "${cfg.modifier}+Shift+Down" = "move down";
            "${cfg.modifier}+Shift+Up" = "move up";
            "${cfg.modifier}+Shift+Right" = "move right";

            # focus output - regular
            "${cfg.modifier}+control+Left" = "focus output left";
            "${cfg.modifier}+control+Down" = "focus output down";
            "${cfg.modifier}+control+Up" = "focus output up";
            "${cfg.modifier}+control+Right" = "focus output right";

            # move container to output - regular
            "${cfg.modifier}+control+Shift+Left" = "move container to output left";
            "${cfg.modifier}+control+Shift+Down" = "move container to output down";
            "${cfg.modifier}+control+Shift+Up" = "move container to output up";
            "${cfg.modifier}+control+Shift+Right" = "move container to output right";

            # move workspace to output - regular
            "${cfg.modifier}+control+Shift+Mod1+Left" = "move workspace to output left";
            "${cfg.modifier}+control+Shift+Mod1+Down" = "move workspace to output down";
            "${cfg.modifier}+control+Shift+Mod1+Up" = "move workspace to output up";
            "${cfg.modifier}+control+Shift+Mod1+Right" = "move workspace to output right";

            # focus parent/child
            "${cfg.modifier}+q" = "focus parent";
            "${cfg.modifier}+e" = "focus child";

            # floating
            "${cfg.modifier}+Shift+space" = "floating toggle";
            "${cfg.modifier}+space" = "focus mode_toggle";

            # workspace history switching
            "${cfg.modifier}+Tab" = "workspace back_and_forth";

            # multimedia / laptop
            "XF86AudioLowerVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioRaiseVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioMute" = "exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioMute+Shift" = "exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
            "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";

            # dmenu
            "${cfg.modifier}+r" = "exec ${cfg.menu}";

            # layout handling
            "${cfg.modifier}+b" = "splith";
            "${cfg.modifier}+v" = "splitv";
            "${cfg.modifier}+o" = "layout stacking";
            "${cfg.modifier}+i" = "layout tabbed";
            "${cfg.modifier}+h" = "layout toggle split";
            "${cfg.modifier}+f" = "fullscreen";

            # sway specific
            "${cfg.modifier}+Shift+q" = "kill";
            "${cfg.modifier}+Shift+c" = "reload";

            # mode triggers
            "${cfg.modifier}+Shift+r" = "mode resize";
            "${cfg.modifier}+Delete" = ''mode "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown"'';
          };

          colors = let base16 = config.kw.hexColors; in
            {
              focused = {
                border = base16.base01;
                background = base16.base0D;
                text = base16.base07;
                indicator = base16.base0D;
                childBorder = base16.base0D;
              };
              focusedInactive = {
                border = base16.base02;
                background = base16.base04;
                text = base16.base00;
                indicator = base16.base04;
                childBorder = base16.base04;
              };
              unfocused = {
                border = base16.base01;
                background = base16.base02;
                text = base16.base06;
                indicator = base16.base02;
                childBorder = base16.base02;
              };
              urgent = {
                border = base16.base03;
                background = base16.base08;
                text = base16.base00;
                indicator = base16.base08;
                childBorder = base16.base08;
              };
            };
        };

      wrapperFeatures.gtk = true;

      extraConfig = ''
        hide_edge_borders smart_no_gaps
        smart_borders no_gaps
        title_align center

        ${workspaceBindingsStr}
      '';
    };
}
