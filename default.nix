let
  sources = import ./nix/sources.nix;
  pkgs = import ./pkgs { inherit sources; };
  inherit (pkgs) lib;

  sourceCache = with lib; let
    getSources = sources: removeAttrs sources [ "__functor" ];
    source2drv = value: if isDerivation value.outPath then value.outPath else value;
    sources2drvs = sources: mapAttrs (_: source2drv) (getSources sources);
  in
  recurseIntoAttrs rec {
    local = sources2drvs sources;
    all = attrValues local;
    allStr = toString all;
  };

  root = ./.;

  xargNames = lib.unique (lib.folderList ./config [ "trusted" ] ++ lib.folderList ./config/trusted [ "pkgs" "tf" ]);
  xarg = lib.mapListToAttrs
    (folder: lib.nameValuePair folder (lib.domainMerge {
      inherit folder;
      folderPaths = [ (./config + "/${folder}") (./config/trusted + "/${folder}") ];
    }))
    xargNames;

  metaConfig = {
    config = {
      runners = {
        lazy = {
          file = root;
          args = [ "--show-trace" ];
        };
      };
      _module.args = {
        pkgs = lib.mkDefault pkgs;
      };
    };
  };

  # This is where the meta config is evaluated.
  eval = lib.evalModules {
    modules = lib.singleton metaConfig
      ++ lib.attrValues (removeAttrs xarg.targets [ "common" ])
      ++ (map (host: {
        network.nodes.${host} = {
          imports = config.lib.kw.nodeImport host;
        };
      }) (lib.attrNames xarg.hosts))
      ++ lib.singleton ./config/modules/meta/default.nix;

    specialArgs = {
      inherit sources root;
      meta = self;
    } // xarg;
  };

  # The evaluated meta config.
  inherit (eval) config;

  self = config // { inherit pkgs lib sourceCache sources; } // xarg;

in self
