{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.1.0+124-1870e898-SNAPSHOT";
  outputHash = "sha256-eDH5iJgLPIKr1rO5PrjFKvP/PCiMn3aSVYjVk8PNqwo=";
}
