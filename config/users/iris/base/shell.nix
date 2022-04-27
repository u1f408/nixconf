{ pkgs, ... }:

{
  programs.command-not-found.enable = false;

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting ""
    '';
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
}
