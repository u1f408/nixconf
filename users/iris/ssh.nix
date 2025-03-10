{ pkgs
, lib
, ...
}:

{
  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
    inheritType = "any";
    extraFlags = [ "--quick" "--ignore-missing" ];
    keys = [ "id_rsa" "id_ed25519" ];
  };

  systemd.user.services.ssh-agent = {
    Unit = {
      Description = "SSH agent";
      After = [ "network.target" ];
    };

    Install.WantedBy = [ "default.target" ];

    Service = {
      Type = "simple";
      ExecStart = "/bin/sh -c 'systemctl --user set-environment SSH_AUTH_SOCK=$SSH_AUTH_SOCK; echo SSH_AUTH_SOCK=$SSH_AUTH_SOCK | tee $HOME/.keychain/env; ssh-agent -D -a $SSH_AUTH_SOCK'";

      Environment = [
        "SSH_AUTH_SOCK=%t/ssh-agent.sock"
        "PATH=/run/current-system/sw/bin:${lib.makeBinPath (with pkgs; [ bashInteractive openssh ])}"
      ];
    };
  };
}
