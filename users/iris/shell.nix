{ pkgs
, lib
, ...
}:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
      cat = "bat";
    };

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      character = {
        success_symbol = "λ";
        error_symbol = "⤬";
      };

      username = {
        show_always = true;
        format = "[$user]($style) at ";
      };

      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname]($style) in ";
      };
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };
}
