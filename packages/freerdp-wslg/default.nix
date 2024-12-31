{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  docbook-xsl-nons,
  libxslt,
  pkg-config,
  alsa-lib,
  faad2,
  glib,
  openh264,
  openssl,
  pcre2,
  zlib,
  libX11,
  libXcursor,
  libXdamage,
  libXdmcp,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  libXtst,
  libXv,
  libxkbcommon,
  libxkbfile,
  wayland,
  wayland-scanner,
  libunwind,
  orc,
  cairo,
  libusb1,
  libpulseaudio,
  cups,
  systemd,
  libjpeg_turbo,
  buildPackages,
}:

let
  cmFlag = flag: if flag then "ON" else "OFF";
  disabledTests =
    [
      # this one is probably due to our sandbox
      {
        dir = "libfreerdp/crypto/test";
        file = "Test_x509_cert_info.c";
      }
    ];

  inherit (lib) optionals;

in
stdenv.mkDerivation rec {
  pname = "freerdp";
  version = "2.4.0+wslg";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "FreeRDP-mirror";
    rev = "c4030980b29322a9cb2190711a5fadeeeb8b6a33";
    hash = "sha256-F6fToXM9veiLIdqmiskQXcsdkjHHqUg1PL/aVs5Kt+c=";
  };

  postPatch =
    ''
      export HOME=$TMP

      # failing test(s)
      ${lib.concatMapStringsSep "\n" (e: ''
        substituteInPlace ${e.dir}/CMakeLists.txt \
          --replace ${e.file} ""
        rm ${e.dir}/${e.file}
      '') disabledTests}

      substituteInPlace "libfreerdp/freerdp.pc.in" \
        --replace "Requires:" "Requires: @WINPR_PKG_CONFIG_FILENAME@"
    '';

  buildInputs =
    [
      cairo
      cups
      faad2
      glib
      libX11
      libXcursor
      libXdamage
      libXdmcp
      libXext
      libXi
      libXinerama
      libXrandr
      libXrender
      libXtst
      libXv
      libjpeg_turbo
      libpulseaudio
      libunwind
      libusb1
      libxkbcommon
      libxkbfile
      openh264
      openssl
      orc
      pcre2
      zlib

      alsa-lib
      systemd
      wayland
    ];

  nativeBuildInputs = [
    cmake
    libxslt
    docbook-xsl-nons
    pkg-config
    wayland-scanner
  ];

  doCheck = true;

  # https://github.com/FreeRDP/FreeRDP/issues/8526#issuecomment-1357134746
  cmakeFlags =
    [
      "-Wno-dev"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DDOCBOOKXSL_DIR=${docbook-xsl-nons}/xml/xsl/docbook"
    ]
    ++ lib.mapAttrsToList (k: v: "-D${k}=${cmFlag v}") {
      BUILD_TESTING = false; # false is recommended by upstream
      WITH_CAIRO = (cairo != null);
      WITH_CUPS = (cups != null);
      WITH_FAAD2 = (faad2 != null);
      WITH_JPEG = (libjpeg_turbo != null);
      WITH_PULSE = (libpulseaudio != null);

      WITH_OSS = false;
      WITH_MANPAGES = false;
      WITH_VAAPI = false;
      WITH_X11 = false;
      WITH_OPENH264 = true;
      WITH_FFMPEG = false;
      WITH_DSP_FFMPEG = false;
      WITH_RDPSND_DSOUND = true;
      CHANNEL_URBDRC = true;
      WITH_SERVER = true;
    };

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=incompatible-function-pointer-types"
    ]
  );

  meta = with lib; {
    description = "Remote Desktop Protocol Client (Microsoft WSLg)";
    homepage = "https://github.com/microsoft/FreeRDP-mirror";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
