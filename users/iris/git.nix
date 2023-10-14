{ inputs
, pkgs
, lib
, ...
}:

{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "Iris System";
    userEmail = "iris@iris.ac.nz";

    aliases = {
      st = "status -sb";
      ll = "log --oneline --graph";
      last = "log -1 HEAD --stat";
      undo = "reset HEAD~1 --mixed";
    };

    extraConfig = {
      init.defaultBranch = "main";
      url."ssh://git@github.com/".pushInsteadOf = "https://github.com/";
      url."ssh://git@git.sr.ht/".pushInsteadOf = "https://git.sr.ht/";
    };
  };
}