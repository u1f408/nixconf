{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, super ? if !isOverlayLib then lib else { }
, self ? if !isOverlayLib then lib else { }
, before ? if !isOverlayLib then lib else { }
, isOverlayLib ? false
}@args:

let
  lib = before // iris // self;
  iris = with before; with iris; with self;
    {
      # don't ask me why this is here
      inherit (super) intersectLists genAttrs;

      listToAttrs = super.foldl' (acc: val: acc // { ${val.name} = val.value; }) { };
      mapListToAttrs = f: l: listToAttrs (map f l);

      moduleList = import ./module-list.nix { inherit lib; };
      moduleListMerge = import ./intersect-merge.nix { inherit lib; };
      folderList = import ./folder-list.nix { inherit lib; };
      domainMerge = import ./domain-merge.nix { inherit lib; };
    };

in
iris
