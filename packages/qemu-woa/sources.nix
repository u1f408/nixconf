{ lib
, fetchurl
, fetchFromGitHub
, fetchFromGitLab
, ...
}:

let
  patchSubprojects =
    srcs: (lib.concatStringsSep "\n" (lib.mapAttrsToList (name: src:
      ''
        cp -R ${src} $PWD/subprojects/${name}
        chmod -R +w $PWD/subprojects/${name}
        test -d $PWD/subprojects/packagefiles/${name} && cp $PWD/subprojects/packagefiles/${name}/* $PWD/subprojects/${name}/
      ''
    ) srcs)) + "\n";

in
{
  # version = "9.0.92";
  # src = fetchFromGitHub {
  #   owner = "gailium119";
  #   repo = "qemu";
  #   rev = "fee0844dc0fcf6b0a85416e15f39246babac9b5e";
  #   hash = "sha256-IDMpchl93S6BTR8JGq0aznxVI63FgIkflLX7iDuDSqg=";
  # };

  version = "9.2.50";
  src = fetchFromGitHub {
    owner = "lzw29107";
    repo = "qemu";
    rev = "a6c0f25b6e0225a65e1c0f90390dd33e97c3b737";
    hash = "sha256-sD7MTmWmkMX3MCd8saLED+rfhQgQTEaP13FLeADMynk=";
  };

  postPatch = patchSubprojects {
    keycodemapdb = fetchFromGitLab {
      owner = "qemu-project";
      repo = "keycodemapdb";
      rev = "f5772a62ec52591ff6870b7e8ef32482371f22c6";
      hash = "sha256-GbZ5mrUYLXMi0IX4IZzles0Oyc095ij2xAsiLNJwfKQ=";
    };

    berkeley-softfloat-3 = fetchFromGitLab {
      owner = "qemu-project";
      repo = "berkeley-softfloat-3";
      rev = "b64af41c3276f97f0e181920400ee056b9c88037";
      hash = "sha256-Yflpx+mjU8mD5biClNpdmon24EHg4aWBZszbOur5VEA=";
    };

    berkeley-testfloat-3 = fetchFromGitLab {
      owner = "qemu-project";
      repo = "berkeley-testfloat-3";
      rev = "e7af9751d9f9fd3b47911f51a5cfd08af256a9ab";
      hash = "sha256-inQAeYlmuiRtZm37xK9ypBltCJ+ycyvIeIYZK8a+RYU=";
    };
  };

  postFixup =
    let
      woahefi-nt6x = fetchurl {
        url = "https://github.com/pivotman319-owo/woahefi-nt6x/releases/download/r0.01/QEMU_EFI_woahefi.fd";
        hash = "sha256-6Jr/42clZmHzK77ExKq27iVvgaBgkM+0VnJIAuru7zk=";
      };
    in ''
      cp ${woahefi-nt6x} $out/share/qemu/woahefi-arm.fd
    '';
}
