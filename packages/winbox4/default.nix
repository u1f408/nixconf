{
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  fontconfig,
  freetype,
  lib,
  libGL,
  libxkbcommon,
  makeDesktopItem,
  makeWrapper,
  stdenvNoCC,
  unzip,
  writeShellApplication,
  xorg,
  zlib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "winbox";
  version = "4.0beta4";

  src = fetchurl {
    name = "WinBox_Linux-${finalAttrs.version}.zip";
    url = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/WinBox_Linux.zip";
    hash = "sha256-MidU5AORZH0NH00jQaoXs2Jk9i5W+iXWCPgRK9QnW6E=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    # makeBinaryWrapper does not support --run
    makeWrapper
    unzip
  ];

  buildInputs = [
    fontconfig
    freetype
    libGL
    libxkbcommon
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 "assets/img/winbox.png" "$out/share/pixmaps/winbox.png"
    install -Dm755 "WinBox" "$out/bin/WinBox"

    wrapProgram "$out/bin/WinBox" --run "${lib.getExe finalAttrs.migrationScript}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "winbox";
      desktopName = "Winbox";
      comment = "GUI administration for Mikrotik RouterOS";
      exec = "WinBox";
      icon = "winbox";
      categories = [ "Utility" ];
    })
  ];

  migrationScript = writeShellApplication {
    name = "winbox-migrate";
    text = ''
      XDG_DATA_HOME=''${XDG_DATA_HOME:-$HOME/.local/share}
      sourceFile="$HOME/.wine/drive_c/users/$USER/Application Data/Mikrotik/Winbox/Addresses.cdb"
      targetFile="$XDG_DATA_HOME/MikroTik/WinBox/Addresses.cdb"

      if [ ! -f "$sourceFile" ]; then
        echo "NixOS: WinBox 3 data not found at $(dirname "$sourceFile"). Skipping automatic migration."
        exit 0
      fi

      if [ -f "$targetFile" ]; then
        echo "NixOS: WinBox 4 data already present at $(dirname "$targetFile"). Skipping automatic migration."
        exit 0
      fi

      echo "NixOS: Automatically migrating WinBox 3 data..."
      mkdir -p "$(dirname "$targetFile")"
      cp "$sourceFile" "$targetFile"
    '';
  };

  meta = {
    description = "Graphical configuration utility for RouterOS-based devices";
    homepage = "https://mikrotik.com";
    downloadPage = "https://mikrotik.com/download";
    changelog = "https://wiki.mikrotik.com/wiki/Winbox_changelog";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "WinBox";
    maintainers = with lib.maintainers; [
      Scrumplex
      yrd
    ];
  };
})
