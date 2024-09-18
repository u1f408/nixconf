{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.iris;
  envVars = {
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/ssh-agent";
  };

in
{
  options = {
    iris.enableSSHAgent = mkEnableOption "user SSH agent" // { default = true; };
  };

  config = {
    home.sessionVariables = mkIf cfg.enableSSHAgent envVars;
    systemd.user.sessionVariables = mkIf cfg.enableSSHAgent envVars;

    systemd.user.services.ssh-agent = mkIf cfg.enableSSHAgent {
      Install.WantedBy = [ "default.target" ];
      Unit.Description = "SSH authentication agent";
      Unit.Documentation = [ "man:ssh-agent(1)" ];

      Service = {
        ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a %t/ssh-agent";
      };
    };
  };
}
