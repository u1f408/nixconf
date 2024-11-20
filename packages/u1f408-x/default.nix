{ buildGoModule
, fetchFromGitHub
, ...
}:

buildGoModule rec {
  pname = "u1f408-x";
  version = "20241015";

  vendorHash = "sha256-8dokNgrjHEI2cWqjQOWHf9vH/ZAX8LGUN+QdZwGcdbc=";
  src = fetchFromGitHub {
    owner = "u1f408";
    repo = "x";
    rev = "5aa7d8e2bb282a9713d61383dfa46ece1db349a8";
    hash = "sha256-45yAcAIbBclTFyo7GOcoIxHLoYP8H9dIOVtwKEGxc0I=";
  };

  ldflags = [ "-X main.Version=${version}" ];
  subPackages = [
    "proxyssh"
    "box"
  ];
}
