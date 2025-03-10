{ lib
, fetchurl
, buildFHSEnv
, libarchive
, binutils
}:

let
  version = "2023.3.1.10";
  src = fetchurl {
    url = "https://cdn.devolutions.net/download/Linux/RDM/${version}/RemoteDesktopManager_${version}_amd64.deb";
    hash = "sha256-E9GtlT4PKOUZtfMn0PG64NMZ7BpRIldhIzqncsgJZgw=";
  };

in buildFHSEnv {
  pname = "remotedesktopmanager";
  inherit version;

  targetPkgs = (pkgs: with pkgs; [
    libGL
    libdrm
    mesa
    libva
    udev
    libudev0-shim

    xorg.libX11
    xorg.libICE
    xorg.libXext

    openssl
    gnutls
    zlib
    gss
    krb5
    cups
    icu
    gtk3
    vte
    glib
    glib-networking
    libsoup
    libsoup_3
    webkitgtk
    webkitgtk_4_1
    lttng-ust_2_12
    libxcrypt-legacy
  ]);

  profile = ''
    export LIBGL_DRIVERS_PATH=/run/opengl-driver/lib/dri
    export __EGL_VENDOR_LIBRARY_DIRS=/run/opengl-driver/share/glvnd/egl_vendor.d
    export LIBVA_DRIVERS_PATH=/run/opengl-driver/lib/dri
    export VDPAU_DRIVER_PATH=/run/opengl-driver/lib/vdpau
  '';

  extraBuildCommands = ''
    "${binutils}/bin/ar" p "${src}" data.tar.xz | "${libarchive}/bin/bsdtar" -C "$out" -xp usr/
  '';

  extraInstallCommands = ''
    install -Dm755 "${./remotedesktopmanager.desktop}" "$out/share/applications/remotedesktopmanager.desktop"
    install -Dm644 "${./remotedesktopmanager.svg}" "$out/share/icons/hicolor/scalable/apps/remotedesktopmanager.svg"
  '';

  privateTmp = true;
  runScript = "/usr/lib/devolutions/RemoteDesktopManager/RemoteDesktopManager";

  meta = with lib; {
    description = "Devolutions Remote Desktop Manager";
    homepage = "https://devolutions.net/remote-desktop-manager/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
