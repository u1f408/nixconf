{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    exa
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;

    initExtra = ''
      __prompt_userhost() {
        if [[ "x''${USER}x" != xiris && "x''${SUDO_UID}x" != xx ]]
        then
          printf '%s@' "$USER"
        fi
        printf '%s' "$HOSTNAME"
      }

      __prompt() {
        printf '%s%% ' "$(__prompt_userhost)"
      }

      PS1="\$(__prompt)"
    '';

    shellAliases = {
      ls = "exa -F --git";
      ll = "ls -la";
    };
  };

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    extraFlags = [ "--quiet" "--nogui" ];
    inheritType = "local";
    keys = [ "id_rsa" "id_ed25519" ];
  };

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "base16";
    };
  };
}
