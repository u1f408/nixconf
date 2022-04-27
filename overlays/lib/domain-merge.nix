{ lib }:
{ folder, defaultFile ? "default.nix", folderPaths ? [ ] }:

with lib;
with builtins;

let
  defaultFileFinal =
    if (defaultFile == "default.nix" && folder == "hosts") then
      "nixos.nix"
    else defaultFile;
  folderModLists = map
    (folderPath: moduleList {
      modulesDir = folderPath;
      defaultFile = defaultFileFinal;
    })
    (filter builtins.pathExists folderPaths);
in
foldl' moduleListMerge { } folderModLists
