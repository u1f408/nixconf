{ pkgs
, lib
, ...
}:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;

    ensureDatabases = [ "lldap" ];
    ensureUsers = [
      { name = "lldap"; ensureDBOwnership = true; }
    ];
  };
}
