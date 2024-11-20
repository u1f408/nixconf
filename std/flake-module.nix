{ inputs, ... }@toplevel:
let
  std' = import ./. toplevel;
in
{
  _module.args.std = std';
  flake.lib = std';
}