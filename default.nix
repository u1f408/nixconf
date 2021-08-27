let
  sources = import ./nix/sources.nix;
  pkgs = import ./pkgs { inherit sources; };
  inherit (pkgs) lib; 

  root = ./.;

  xargNames = lib.unique (lib.folderList ./config [ "hosts" "trusted" ] ++ lib.folderList ./config/trusted [ "pkgs" "tf" ]);
  xarg = lib.mapListToAttrs
    (folder: lib.nameValuePair folder (lib.domainMerge {
      inherit folder;
      folderPaths = [ (./config + "/${folder}") (./config/trusted + "/${folder}") ];
    }))
    xargNames;

  hosts = (import ./config/hosts {
    inherit root pkgs sources;
    meta = xarg;
  });
  
  inherit (import ./lib/deploy.nix {
    inherit pkgs hosts;
  }) deploy;

in rec {
  inherit xarg;
  inherit hosts deploy;
}
