{ config, pkgs, lib, ... }:

let
  font' = { name = "Comic Code"; size = 10.0; };
  base16' = {
    light = "summerfruit.summerfruit-light";
    dark = "porple.porple";
  };

in
{
  base16 = {
    shell.enable = true;
    schemes = [ base16'.light base16'.dark ];
    alias = {
      inherit (base16') light dark;
      default = lib.mkDefault base16'.dark;
    };
  };

  kw.font = font';
  kw.hexColors = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex.rgb}")
    (lib.filterAttrs (n: _: lib.hasInfix "base" n) config.lib.arc.base16.schemeForAlias.default);
}
