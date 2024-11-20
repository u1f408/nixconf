{ inputs
, ...
}@toplevel:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit (toplevel) inputs meta _passthru;
    };
  };
}