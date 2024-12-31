{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  wayland-scanner,
  cairo,
  colord,
  libGL,
  libdisplay-info,
  libdrm,
  libevdev,
  libinput,
  libxkbcommon,
  mesa,
  pam,
  wayland,
  wayland-protocols,
  xcbutilcursor,
  freerdp-wslg,

  jpegSupport ? true,
  libjpeg,
  lcmsSupport ? true,
  lcms2,
  pangoSupport ? true,
  pango,
  webpSupport ? true,
  libwebp,
  xwaylandSupport ? true,
  libXcursor,
  xwayland,
}:

stdenv.mkDerivation rec {
  pname = "weston";
  version = "9.0.0+wslg";

 src = fetchFromGitHub {
    owner = "microsoft";
    repo = "weston-mirror";
    rev = "f227edd681479ec3cb2290a25d84d2d3462aebfa";
    hash = "sha256-zOH0JNLX0BX+ILD9wnaMmiP05KPPWOhAQpQr6ZJWLlo=";
  };

  postPatch =
    ''
      sed -z 's/RemoteFxCodec = FALSE/RemoteFxCodec = TRUE/' -i libweston/backend-rdp/rdp.c
      sed -z 's/context->SetVolume/\/\/context->SetVolume/' -i compositor/rdpaudio.c
    '';

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
  ];
  buildInputs =
    [
      cairo
      colord
      libGL
      libdisplay-info
      libdrm
      libevdev
      libinput
      libxkbcommon
      mesa
      pam
      wayland
      wayland-protocols
      freerdp-wslg
    ]
    ++ lib.optional jpegSupport libjpeg
    ++ lib.optional lcmsSupport lcms2
    ++ lib.optional pangoSupport pango
    ++ lib.optional webpSupport libwebp
    ++ lib.optionals xwaylandSupport [
      libXcursor
      xcbutilcursor
      xwayland
    ];

  mesonFlags =
    [
      (lib.mesonBool "launcher-logind" false)
      (lib.mesonBool "pipewire" false)
      (lib.mesonBool "backend-rdp" true)
      (lib.mesonBool "backend-x11" false)
      (lib.mesonBool "backend-headless" false)
      (lib.mesonBool "backend-drm" false)
      (lib.mesonBool "backend-drm-screencast-vaapi" false)
      (lib.mesonOption "backend-default" "rdp")
      (lib.mesonBool "shell-rdprail" false)
      (lib.mesonBool "color-management-lcms" lcmsSupport)
      (lib.mesonBool "image-jpeg" jpegSupport)
      (lib.mesonBool "image-webp" webpSupport)
      (lib.mesonBool "remoting" false)
      (lib.mesonBool "test-junit-xml" false)
      (lib.mesonBool "xwayland" xwaylandSupport)
    ]
    ++ lib.optionals xwaylandSupport [
      (lib.mesonOption "xwayland-path" (lib.getExe xwayland))
    ];

  meta = with lib; {
    description = "Lightweight and functional Wayland compositor (Microsoft WSLg)";
    homepage = "https://github.com/microsoft/weston-mirror";
    license = licenses.mit; # Expat version
    platforms = platforms.linux;
    mainProgram = "weston";
  };
}
