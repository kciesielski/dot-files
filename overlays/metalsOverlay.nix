{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.2.0+71-b6841c5a-SNAPSHOT";
  outputHash = "sha256-Dt66itYgeD1vaooVBRgpPYlRcsHmJDiDhOZt9F7LNVI=";
}
