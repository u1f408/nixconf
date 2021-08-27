{ lib }: { nixosImports, homeImports, users, hostName, profiles }: with lib;

let
  importLists = {
    nixos = nixosImports;
    home = homeImports;
  };
  replacedLists = mapAttrs
    (_: fileList:
      map (builtins.replaceStrings [ "HN" ] [ "${hostName}" ]) fileList
    )
    importLists;
  homeScaffold = user: {
    home-manager.users.${user} = {
      imports = filter builtins.pathExists replacedLists.home;
    };
  };
  scaffoldedUsers = map homeScaffold users;
  commonProfile = if builtins.isAttrs profiles.common then profiles.common.imports else singleton profiles.common;
in
filter builtins.pathExists replacedLists.nixos ++ commonProfile ++ scaffoldedUsers
