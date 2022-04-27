{ inputs, system, ... }:

let
  pkgs = import ./overlays { inherit inputs system; };
  inherit (pkgs) lib;

  evalConfig = import (inputs.nixpkgs + "/nixos/lib/eval-config.nix");

  xargNames = lib.unique (lib.folderList ./config [ "hosts" ]);
  xarg = lib.mapListToAttrs
    (folder: lib.nameValuePair folder (lib.domainMerge {
      inherit folder;
      folderPaths = [ (./config + "/${folder}") ];
    }))
    xargNames;

  hostConfig = hostName:
    { ... }: {
      imports = [
        "${toString ./config/hosts}/${hostName}"
        meta.profiles.common
      ];

      networking = { inherit hostName; };
    };

  hostNames = lib.folderList ./config/hosts [ ];
  hosts = lib.mapListToAttrs
    (hostName: lib.nameValuePair hostName (hostConfig hostName))
    hostNames;

  meta = xarg // { inherit hosts; };

in meta
