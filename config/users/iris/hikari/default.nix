{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    hikari-session
    wofi
  ];

  programs.fish.shellInit = ''
    # If running from tty1 start Hikari
    if test "/dev/tty1" = (tty)
      systemctl --user unset-environment \
        WAYLAND_DISPLAY \
        DISPLAY \
        IN_NIX_SHELL \
        __HM_SESS_VARS_SOURCED \
        GPG_TTY \
        NIX_PATH \
        SHLVL

      exec env --unset=SHLVL systemd-cat -t hikari -- hikari
    end
  '';

  xdg.configFile."hikari/hikari.conf".text = ''
    ui {
      border = 1
      gap = 5
      step = 100
      font = "Comic Code 9"
    }

    layouts {
      s = {
        scale = {
          min = 0.5
          max = 0.75
        }

        left = single
        right = stack
      }

      f = full
      h = stack
      v = queue
      g = grid
    }

    actions {
      terminal = "alacritty"
      runner-desktop = "wofi --show drun"
      runner = "wofi --show run"
    }

    bindings {
      keyboard {
        "L+Return" = action-terminal
	"L+r" = action-runner-desktop
	"LC+r" = action-runner

        "L+0" = workspace-switch-to-sheet-0
        "L+1" = workspace-switch-to-sheet-1
        "L+2" = workspace-switch-to-sheet-2
        "L+3" = workspace-switch-to-sheet-3
        "L+4" = workspace-switch-to-sheet-4
        "L+5" = workspace-switch-to-sheet-5
        "L+6" = workspace-switch-to-sheet-6
        "L+7" = workspace-switch-to-sheet-7
        "L+8" = workspace-switch-to-sheet-8
        "L+9" = workspace-switch-to-sheet-9
        "LC+n" = workspace-cycle-next
        "LC+p" = workspace-cycle-prev

        "LC+i" = sheet-show-invisible
        "LC+Period" = sheet-show-all
        "LC+g" = sheet-show-group

        "LA+r" = layout-reset
        "L+n" = layout-cycle-view-next
        "L+p" = layout-cycle-view-prev
        "L+x" = layout-exchange-view-next
        "LS+x" = layout-exchange-view-prev
        "LA+x" = layout-exchange-view-main

        "LS+0" = view-pin-to-sheet-0
        "LS+1" = view-pin-to-sheet-1
        "LS+2" = view-pin-to-sheet-2
        "LS+3" = view-pin-to-sheet-3
        "LS+4" = view-pin-to-sheet-4
        "LS+5" = view-pin-to-sheet-5
        "LS+6" = view-pin-to-sheet-6
        "LS+7" = view-pin-to-sheet-7
        "LS+8" = view-pin-to-sheet-8
        "LS+9" = view-pin-to-sheet-9

        "L+u" = view-raise
        "L+d" = view-lower
        "L+o" = view-only
        "L+h" = view-hide
        "L+q" = view-quit

        "L+Up" = view-move-up
        "L+Down" = view-move-down
        "L+Left" = view-move-left
        "L+Right" = view-move-right
        "LA+Up" = view-decrease-size-up
        "LAS+Up" = view-increase-size-up
        "LA+Down" = view-increase-size-down
        "LAS+Down" = view-decrease-size-down
        "LA+Left" = view-decrease-size-left
        "LAS+Left" = view-increase-size-left
        "LA+Right" = view-increase-size-right
        "LAS+Right" = view-decrease-size-right
        "LS+Up" = view-snap-up
        "LS+Down" = view-snap-down
        "LS+Left" = view-snap-left
        "LS+Right" = view-snap-right
        "LS+r" = view-reset-geometry

        "L+f" = view-toggle-maximize-full

        "LS+o" = group-only
        "LS+h" = group-hide
        "LS+u" = group-raise
        "LS+d" = group-lower
        "L+Tab" = group-cycle-prev
        "LS+Tab" = group-cycle-next
        "L+asciicircum" = group-cycle-view-prev
        "LS+asciicircum" = group-cycle-view-next
        "LS+Home" = group-cycle-view-first
        "LS+End" = group-cycle-view-last

        "LS+Backspace" = lock
        "LCA+q" = quit
        "LCA+r" = reload

        "A+F1" = vt-switch-to-1
        "A+F2" = vt-switch-to-2
        "A+F3" = vt-switch-to-3
        "A+F4" = vt-switch-to-4
        "A+F5" = vt-switch-to-5
        "A+F6" = vt-switch-to-6
        "A+F7" = vt-switch-to-7
        "A+F8" = vt-switch-to-8
        "A+F9" = vt-switch-to-9
      }

      mouse {
        "L+left" = mode-enter-move
        "L+right" = mode-enter-resize
      }
    }

    inputs {
      keyboards {
        "*" = {
          xkb = {
            layout = "us"
            variant = "dvorak"
            options = "compose:caps"
          }
        }
      }
    }
  '';
}
