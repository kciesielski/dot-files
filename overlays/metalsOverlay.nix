{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.1.0+17-728623ba-SNAPSHOT";
  outputHash = "sha256-CldHzFMvFWoKWP6Nx3cmX89JbMaQ6t7Ye3Cx5A5NxWU=";
}
