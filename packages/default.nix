toplevel @ { inputs, ... }: pkgs:

with pkgs.lib;
let
  system = pkgs.stdenv.hostPlatform.system or pkgs.system;

in
{
}
