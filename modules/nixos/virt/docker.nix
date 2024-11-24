{ pkgs
, lib
, ...
}:

{
  u1f408.immutableUsers.extraAdminGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      userland-proxy = false;
      experimental = true;
    };
  };
}
