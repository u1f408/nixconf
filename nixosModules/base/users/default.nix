{ inputs
, config
, pkgs
, lib
, meta
, ...
} @ args:

with lib;
let
  cfg = config.iris;
  knownUsers = (import ./users.nix) args;

  mkHomeManager = user:
    { meta, ... }@args: {
      imports = [
        meta.homeModules.base
        meta.homeConfigurations."${user}"
      ];
    };

in
{
  options.iris = {
    useImmutableUserConfig = mkEnableOption "immutable user configuration" // { default = true; };
  };

  config = mkIf cfg.useImmutableUserConfig {
    users.mutableUsers = false;

    users.users =
      (mapAttrs (user: desc: {
        inherit (desc) uid hashedPassword;
        isNormalUser = true;
        shell = if (desc ? shell) then desc.shell else pkgs.bash;
        openssh.authorizedKeys.keyFiles = [ ./sshKeys/${user} ];
        extraGroups = mkMerge [
          (mkIf (desc ? isAdmin) [ "wheel" "systemd-journal" ])
        ];
      }) knownUsers) // {
        root = {
          initialHashedPassword = "";
          openssh.authorizedKeys.keyFiles = with lib; (flatten (attrValues (mapAttrs (user: desc: if desc.isAdmin then [ ./sshKeys/${user} ] else []) knownUsers)));
        };
      };

    home-manager.users = mapAttrs (user: desc: (mkIf desc.useHomeManager (mkHomeManager user args))) knownUsers;
  };
}
