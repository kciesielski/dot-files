{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.3.5";
  outputHash = "sha256-86/zeoOO5kSAwh7uQTV7nGUGQoIux1rlH5eUgvn3kvY=";
}
