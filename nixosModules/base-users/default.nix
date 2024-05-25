{ inputs
, pkgs
, lib
, meta
, ...
} @ args:

let
  knownUsers = (import ./users.nix) args;

in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.mutableUsers = false;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit (args) inputs meta _passthru;
    };
  };

  users.users =
    (with lib; (mapAttrs (user: desc: {
      inherit (desc) uid hashedPassword;
      isNormalUser = true;
      shell = if (desc ? shell) then desc.shell else pkgs.bash;
      openssh.authorizedKeys.keyFiles = [ ./sshKeys/${user} ];
      extraGroups = mkMerge [
        (mkIf (desc ? isAdmin) [ "wheel" "systemd-journal" ])
      ];
    }) knownUsers)) // {
      root = {
        initialHashedPassword = "";
        openssh.authorizedKeys.keyFiles = with lib; (flatten (attrValues (mapAttrs (user: desc: if desc.isAdmin then [ ./sshKeys/${user} ] else []) knownUsers)));
      };
    };

  home-manager.users = with lib; (mapAttrs (user: desc: (mkIf desc.useHomeManager (meta.homeConfigurations."${user}" args))) knownUsers);
}
