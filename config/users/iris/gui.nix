{ pkgs, lib, ... }:

{
  home-manager.users.iris = {
    imports = [
      ./gui
    ];
  };
}
