{ pkgs
, lib
, ...
}:

{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    aliases = {
      co = "commit -s";
      st = "status -sb";
      ll = "log --oneline --graph";
      last = "log -1 HEAD --stat";
      undo = "reset HEAD~1 --mixed";
      cached = "diff --cached";
    };

    extraConfig = {
      user = {
        name = "Iris System";
        email = "iris@iris.ac.nz";
      };

      init.defaultBranch = "main";
      rebase.autoStash = true;
      pull.rebase = true;

      url."ssh://git@github.com/".pushInsteadOf = "https://github.com/";
      remote."origin".fetch = "+refs/notes/*:refs/notes/*";
      notes.displayRef = "refs/notes/*";

      diff = {
        noprefix = true;
        colormoved = "default";
        colormovedws = "allow-indentation-change";
      };
    };

    includes = [
      { path = "~/.gitconfig.local"; }
    ];
  };
}
