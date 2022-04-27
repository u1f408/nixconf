{ inputs, meta, pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.wsl.nixosModules.wsl
  ];
}
