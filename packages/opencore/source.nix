{ fetchurl
}:

let
  version = "1.0.2";
in
{
  inherit version;
  src = fetchurl {
    name = "OpenCore-${version}-RELEASE.zip";
    url = "https://github.com/acidanthera/OpenCorePkg/releases/download/${version}/OpenCore-${version}-RELEASE.zip";
    hash = "sha256-7UiKbLrcMAEXnnt5rirjzT5IFwwcmhsVcqNPme5RPk4=";
  };
}
