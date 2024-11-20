{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

let
  src' = import ./source.nix { inherit fetchurl; };

in
stdenvNoCC.mkDerivation {
  pname = "opencore-drivers";
  inherit (src') version src;
  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/opencore-drivers"
    for ocArch in IA32 X64
    do
      mkdir -p "$out/share/opencore-drivers/$ocArch"
      cp "./$ocArch/EFI/OC/Drivers"/*.efi "$out/share/opencore-drivers/$ocArch"
    done

    runHook postInstall
  '';  
}
