{ meta
, pkgs
, ...
}:

{
  darcy = {
    uid = 1000;
    isAdmin = true;
    shell = pkgs.fish;
    description = "Darcy Iris";
    sshKeyFiles = [ "${meta}/users/darcyProdigi/authorized_keys" ];
    hashedPassword = "$y$j9T$z7JS6B0cpr3ygE6oILEiW0$InFvGn7wq71.9cwKa6QAkWUGB6/qC6MX8t.VKacpQA7";

    homeManagerEnable = true;
    homeManagerPaths = [
      meta.homeManagerUsers.darcyProdigi
    ];
  };
}
