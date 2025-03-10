{ meta
, pkgs
, ...
}:

let
  sshKeys = user: [
    "${meta}/users/${user}/authorized_keys"
  ];

{
  iris = {
    uid = 1000;
    isAdmin = true;
    shell = pkgs.fish;
    sshKeyFiles = sshKeys iris;
    hashedPassword = "$y$j9T$z7JS6B0cpr3ygE6oILEiW0$InFvGn7wq71.9cwKa6QAkWUGB6/qC6MX8t.VKacpQA7";

    homeManagerEnable = true;
  };
}
