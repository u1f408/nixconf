{ pkgs
, lib
, ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [
      zlib
      openssl.dev
      pkg-config
    ]);

    extensions = with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh

      yzhang.markdown-all-in-one
      jeff-hykin.better-nix-syntax
      redhat.ansible
      ms-python.python
      golang.go
    ];
  };
}
