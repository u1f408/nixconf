{ lib, root, sources, config, ... }:

with lib;

{
  options.home-manager.users = mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = singleton (root + "/config/modules/home");
      specialArgs = {
        inherit sources;
        superConfig = config;
        modulesPath = sources.home-manager + "/modules";
      };
    });
  };

  config.home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
