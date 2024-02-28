{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.2.2+41-4ecdb894-SNAPSHOT";
  outputHash = "sha256-R/Xl0+V0s+rpLG8UmivmtXPbbXhMjaVKurDDRYUr2ck=";
}
