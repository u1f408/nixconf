{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    exa
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;

    shellAliases = {
      ls = "exa -F --git";
      ll = "ls -la";
    };
  };

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    extraFlags = [ "--quiet" ];
    inheritType = "local";
  };

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "base16";
    };
  };
}
