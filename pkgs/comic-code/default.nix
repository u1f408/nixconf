{ stdenv, fetchzip }:

stdenv.mkDerivation {
  pname = "comic-code";
  version = "1.0";

  src = fetchzip {
    url = "https://lauren-dump.sfo2.digitaloceanspaces.com/comiccode.zip";
    sha256 = "sha256:0cig8a2mgkzczjci93v88vvkbyzrcd2v2d71nspq9ms4l2h5dlw6";
    stripRoot = false;
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -pv $out/share/fonts/opentype
    cp -v *.otf $out/share/fonts/opentype
  '';
}
