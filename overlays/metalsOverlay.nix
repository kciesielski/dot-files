{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.3.0";
  outputHash = "sha256-otN4sqV2a0itLOoJ7x+VSMe0tl3y4WVovbA1HOpZVDw=";
}
