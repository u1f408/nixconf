{ config
, meta
, pkgs
, lib
, ...
}@toplevel:

with lib;

let
  cfg = config.u1f408.immutableUsers;
  knownUsers = import ./users.nix toplevel;
  adminGroups = [ "wheel" "systemd-journal" ] ++ cfg.extraAdminGroups;

  mkUserDesc = user: desc: {
    inherit (desc) uid hashedPassword;
    isNormalUser = true;
    shell = if (desc ? shell) then desc.shell else pkgs.bash;
    openssh.authorizedKeys.keyFiles = [ "${meta}/users/${user}/authorized_keys" ];
    extraGroups = mkMerge [
      (mkIf (desc ? isAdmin) adminGroups)
    ];
  };

  mkHomeManager = user:
    { meta, ... }@toplevel: {
      imports = [
        meta.homeModules.base
        meta.homeConfigurations."${user}"
      ];
    };

in
{
  options.u1f408.immutableUsers = {
    enable = mkEnableOption "immutable user configuration" // { default = true; };
    extraAdminGroups = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    users.mutableUsers = lib.mkForce false;
    users.users =
      (mapAttrs mkUserDesc knownUsers) // {
        root = {
          initialHashedPassword = "";
          openssh.authorizedKeys.keyFiles =
            (flatten (attrValues (mapAttrs
              (user: desc: if desc.isAdmin then [ "${meta}/users/${user}/authorized_keys" ] else [ ])
              knownUsers)));
        };
      };

    home-manager.users =
      (mapAttrs
        (user: desc: mkIf desc.useHomeManager (mkHomeManager user toplevel))
        knownUsers);
  };
}
