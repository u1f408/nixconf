{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting ""
      set -gx fish_user_paths $HOME/.local/bin
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      character = {
        success_symbol = "[λ](green)";
        error_symbol = "[λ](bold red)";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;

    stdlib = ''
      # use cache outside of $PWD
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
        echo "''${direnv_layout_dirs[$PWD]:=$(
          echo -n "$XDG_CACHE_HOME"/direnv/layouts/
          echo -n "$PWD" | shasum | cut -d ' ' -f 1
        )}"
      }
    '';
  };

  programs.command-not-found.enable = false;
}
