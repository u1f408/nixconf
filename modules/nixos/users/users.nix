{ inputs
, pkgs
, lib
, ...
}:

let
  adminGroups = [ "wheel" "systemd-journal" ];

in rec {
  iris = {
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.bash;
    useDefaultShell = false;
    extraGroups = adminGroups ++ [ ];
    hashedPassword = "$y$j9T$TxgF7gWLmRwj1Hb8lVN4D1$UaN60ZVUnlxshvmny38IvZbYrwu2DPja.uLNVPRwrK5";
  };
}
