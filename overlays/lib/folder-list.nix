{ lib }:
path: excludes:

with builtins;
with lib;

let
  filterAttrNamesToList = filter: set:
    foldl' (a: b: a ++ b) [ ]
      (map (e: if (filter e set.${e}) then [ e ] else [ ]) (attrNames set));
in
(filterAttrNamesToList (name: type: ! (builtins.elem name excludes) && type == "directory") (builtins.readDir path))
