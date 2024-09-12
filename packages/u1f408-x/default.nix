{ buildGoModule
, fetchFromGitHub
, ...
}:

buildGoModule rec {
  pname = "u1f408-x";
  version = "20240912";

  vendorHash = "sha256-kSP70NpnEOyeQjsuNjqOdsvdwQtebLl5oH1ySadxsUI=";
  src = fetchFromGitHub {
    owner = "u1f408";
    repo = "x";
    rev = "ca272e736aa00d685e327b145cc0b1d7fc09671a";
    hash = "sha256-AeOjmyGlb8h/RjWFPX6aRMtgN8+UkXVcRIz0ijtabQ4=";
  };

  ldflags = [ "-X main.Version=${version}" ];
  subPackages = [
    "proxyssh"
    "box"
  ];
}
