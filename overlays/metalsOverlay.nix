{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.2.0+121-b727d7a9-SNAPSHOT";
  outputHash = "sha256-hWb9W4zqWm/IDrRYYYCObZR9VpuQCGXNR2OtA+fuoRY=";
}
