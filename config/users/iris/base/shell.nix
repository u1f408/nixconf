{ pkgs, ... }:

{
  programs.command-not-found.enable = false;

  programs.exa = {
    enable = true;
    enableAliases = false;
  };

  programs.fish = {
    enable = true;

    shellInit = ''
      set -Ue fish_user_paths
      set -gx fish_user_paths ~/.local/bin
    '';

    functions = {
      fish_greeting = ''
        uname -a
      '';

      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };
    };

    shellAliases = {
      ls = "exa --group-directories-first";
      ll = "ls -l --git";
      la = "ll -a";
    };
  };

  programs.direnv = {
    enable = true;
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

  programs.starship = {
    enable = true;

    settings = {
      character = {
        success_symbol = "λ";
        error_symbol = "[🗴](bold red)";
      };
    };
  };

  programs.keychain = {
    enable = true;
    keys = [ "id_rsa" "id_ed25519" ];
    inheritType = "any";
    extraFlags = [ "--confirm" "--quick" "--quiet" ];
  };
}
