{ inputs
, pkgs 
, lib
, ...
}:

{
  programs.home-manager = {
    enable = true;
    path = toString inputs.home-manager;
  };
}
