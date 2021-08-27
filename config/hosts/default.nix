{ sources
, pkgs
, lib ? pkgs.lib
, root
, meta
}:

let
  hosts = {
    pluto = {
      ssh = {
        host = "root@pluto";
        port = 62954;
      };
    };
    ruby = {
      ssh = {
        host = "root@ruby";
        port = 62954;
      };
    };
    luka = {
      ssh = {
        host = "root@luka";
        port = 62954;
      };
    };
    devvm = {
      ssh = {
        host = "root@devvm";
        port = 62954;
      };
    };
    saturn = {
      ssh = {
        host = "root@saturn.smol.systems";
        port = 62954;
      };
    };
    neptune = {
      ssh = {
        host = "root@neptune.smol.systems";
        port = 62954;
      };
    };
  };

  hostConfig = hostName:
    { config, ... }: {
      _module.args = { inherit hosts; };

      imports = [
        "${toString ./.}/${hostName}"
        meta.profiles.common
      ];

      networking = { inherit hostName; };
      nixpkgs.pkgs = import pkgs.path {
        inherit (config.nixpkgs) config;
        inherit sources;
      };
    };

  evalConfig = import (pkgs.path + "/nixos/lib/eval-config.nix");

in
lib.mapAttrs
  (hostName: host:
    host // {
      config = (evalConfig {
        modules = [
          (hostConfig hostName)
          (import meta.modules.nixos)
        ];

        specialArgs = {
	  inherit root meta;
          inherit sources pkgs;
	  inherit hostName;
        };
      }).config;
    })
  hosts

