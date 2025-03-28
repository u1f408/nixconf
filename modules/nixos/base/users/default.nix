{ config
, meta
, pkgs
, lib
, ...
}@toplevel:

with lib;

let
  cfg = config.u1f408.immutableUsers;
  knownUsers = import cfg.userDescs toplevel;
  adminGroups =
    [ "wheel" "systemd-journal" ]
    ++ cfg.extraAdminGroups
    ++ lib.optional config.networking.networkmanager.enable "networkmanager"
    ;

  mkUserDesc = user: desc: {
    inherit (desc) uid hashedPassword;
    isNormalUser = true;
    description = if (desc ? description) then desc.description else "";
    shell = if (desc ? shell) then desc.shell else pkgs.bash;
    openssh.authorizedKeys.keyFiles = if (desc ? sshKeyFiles) then desc.sshKeyFiles else [];
    extraGroups = mkMerge [
      (mkIf (desc ? isAdmin) adminGroups)
    ];
  };

  mkHomeManager = { user, desc, ... }:
    { meta, ... }@toplevel: {
      imports =
        [
          meta.homeManagerModules.base
        ]
        ++ (if (desc ? homeManagerPaths)
          then desc.homeManagerPaths
          else [ meta.homeManagerUsers."${user}" ])
        ;
    };

in
{
  options.u1f408.immutableUsers = {
    enable = mkEnableOption "immutable user configuration" // { default = true; };
    userDescs = mkOption {
      type = types.path;
      default = ./users.nix;
    };

    extraAdminGroups = mkOption {
      type = with types; listOf str;
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
              (user: desc: if desc.isAdmin then desc.sshKeyFiles else [])
              knownUsers)));
        };
      };

    home-manager.users =
      (mapAttrs
        (user: desc: mkIf desc.homeManagerEnable (mkHomeManager { inherit user desc; } toplevel))
        knownUsers);
  };
}
