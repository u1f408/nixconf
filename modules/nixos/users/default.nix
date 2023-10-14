{ config
, options
, pkgs
, lib
, inputs
, ...
}:

with lib;

let
  cfg = config.iris;
  knownUsers = (import ./users.nix) { inherit inputs pkgs lib; };

in
{
  options = {
    iris = {
      enabledUsers = mkOption {
        type = with types; listOf (enum (attrNames knownUsers));
        description = mdDoc "users to enable on this system";
      };
    };
  };

  config = {
    users.mutableUsers = false;
    users.users =
      listToAttrs (map (user: nameValuePair user knownUsers."${user}") cfg.enabledUsers);
  };
}
