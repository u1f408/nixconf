{ pkgs
, lib
, ...
}:


let
  nfsOpts = [ "nfsvers=4" "proto=rdma" ];
in
{
  fileSystems = {
    "/srv/842bd3-vmdata" = {
      device = "10.57.253.21:/srv/842bd3-vmdata";
      fsType = "nfs";
      options = nfsOpts;
    };

    "/srv/bd53c8-vmdata" = {
      device = "10.57.253.21:/srv/bd53c8-vmdata";
      fsType = "nfs";
      options = nfsOpts;
    };
  };
}
