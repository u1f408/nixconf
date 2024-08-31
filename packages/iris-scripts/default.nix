{ stdenv
, lib
, makeWrapper
, wlr-randr
, jq
, bash
}:

let
  deps = [
    bash
    wlr-randr
    jq
  ];

in
stdenv.mkDerivation {
  pname = "iris-scripts";
  version = "1";

  buildInputs = [ makeWrapper ] ++ deps;

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp ${./laptop-rotate.sh} $out/bin/iris-laptop-rotate && chmod +x $out/bin/iris-laptop-rotate

    for fn in $out/bin/*
    do
      wrapProgram $fn --set PATH ${lib.makeBinPath deps}
    done
  '';
}
