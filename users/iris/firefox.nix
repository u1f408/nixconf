{ inputs
, pkgs
, lib
, ...
}:

{
  programs.firefox = {
    enable = true;
  };
}
