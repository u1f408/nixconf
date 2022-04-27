{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;

    userName = "Iris System";
    userEmail = "iris@iris.ac.nz";

    extraConfig = {
      init.defaultBranch = "main";

      url = {
        "https://github.com" = {
          insteadOf = [
            "gh:"
            "github:"
          ];
        };
      };
    };
  };
}
