{ lib, stdenv, python3Packages, zlib, pkg-config, glib
, fetchurl, fetchFromGitHub, fetchFromGitLab
, pixman, vde2, alsa-lib, flex, pcre2
, bison, lzo, snappy, libaio, libtasn1, gnutls, nettle, curl, dtc, ninja, meson
, makeWrapper, removeReferencesTo
, attr, libcap, libcap_ng, socat, libslirp
, sdlSupport ? !stdenv.hostPlatform.isDarwin, SDL2, SDL2_image
, gtkSupport ? !stdenv.hostPlatform.isDarwin, gtk3, gettext, vte, wrapGAppsHook3
, vncSupport ? true, libjpeg, libpng
, spiceSupport ? true, spice, spice-protocol
, ncursesSupport ? true, ncurses
, uringSupport ? stdenv.hostPlatform.isLinux, liburing
}@args:

let
  qemuSources = import ./sources.nix args;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "qemu-woa";
  inherit (qemuSources) src version;

  nativeBuildInputs = [
    makeWrapper removeReferencesTo
    pkg-config flex bison meson ninja dtc

    # Don't change this to python3 and python3.pkgs.*, breaks cross-compilation
    python3Packages.python
  ]
    ++ lib.optionals gtkSupport [ wrapGAppsHook3 ]
    ;

  buildInputs = [
    glib zlib
    dtc pixman vde2 lzo snappy libtasn1 gnutls nettle libslirp
    curl
  ]
    ++ lib.optionals sdlSupport [ SDL2 SDL2_image ]
    ++ lib.optionals gtkSupport [ gtk3 gettext vte ]
    ++ lib.optionals vncSupport [ libjpeg libpng ]
    ++ lib.optionals spiceSupport [ spice-protocol spice ]
    ++ lib.optionals ncursesSupport [ ncurses ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libcap_ng libcap attr libaio ]
    ++ lib.optionals uringSupport [ liburing ]
    ;

  dontUseMesonConfigure = true; # meson's configurePhase isn't compatible with qemu build
  dontAddStaticConfigureFlags = true;
  requiredSystemFeatures = [ "big-parallel" ];

  outputs = [ "out" ];
  separateDebugInfo = true;
  dontWrapGApps = true;

  postPatch = qemuSources.postPatch + ''
    # Otherwise tries to ensure /var/run exists.
    sed -i "/install_emptydir(get_option('localstatedir') \/ 'run')/d" \
        qga/meson.build
  '';

  preConfigure = ''
    unset CPP # intereferes with dependency calculation
    # this script isn't marked as executable b/c it's indirectly used by meson. Needed to patch its shebang
    chmod +x ./scripts/shaderinclude.py
    patchShebangs .
    # avoid conflicts with libc++ include for <version>
    mv VERSION QEMU_VERSION
    substituteInPlace configure \
      --replace '$source_path/VERSION' '$source_path/QEMU_VERSION'
    substituteInPlace meson.build \
      --replace "'VERSION'" "'QEMU_VERSION'"
  '';

  configureFlags = [
    "--disable-strip"
    "--disable-tools"
    "--disable-docs"
    "--disable-plugins"
    "--disable-guest-agent"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--cross-prefix=${stdenv.cc.targetPrefix}"
    "--target-list=arm-softmmu,aarch64-softmmu"
  ]
    ++ lib.optional (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) "--enable-kvm"
    ++ lib.optional stdenv.hostPlatform.isLinux "--enable-linux-aio"
    ++ lib.optional sdlSupport "--enable-sdl"
    ++ lib.optional gtkSupport "--enable-gtk"
    ++ lib.optional vncSupport "--enable-vnc"
    ++ lib.optional spiceSupport "--enable-spice"
    ++ lib.optional uringSupport "--enable-linux-io-uring"
    ++ lib.optional stdenv.hostPlatform.isStatic "--static"
    ;

  preBuild = "cd build";
  doCheck = false;

  postFixup = qemuSources.postFixup + ''
    # none of these are necessary
    rm -rf $out/share/applications
    rm -rf $out/share/icons
  '' + lib.optionalString gtkSupport ''
    # wrap GTK Binaries
    for f in $out/bin/qemu-system-*; do
      wrapGApp $f
    done
  '' + lib.optionalString stdenv.hostPlatform.isStatic ''
    # https://github.com/NixOS/nixpkgs/issues/83667
    rm -f $out/nix-support/propagated-build-inputs
  '';

  meta = with lib; {
    homepage = "https://www.qemu.org/";
    description = "Generic and open source machine emulator and virtualizer (fork for Windows on ARM guests)";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "qemu-system-aarch64";
  };
})
