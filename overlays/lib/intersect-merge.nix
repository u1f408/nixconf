{ lib }: pathsA: pathsB:

with lib;
with builtins;

let
  pathIntersection = intersectLists (attrNames pathsA) (attrNames pathsB);
  pathMerger = pathA: pathB: { imports = [ pathA pathB ]; };
in
pathsA // pathsB // genAttrs pathIntersection (key: (pathMerger pathsA.${key} pathsB.${key}))
