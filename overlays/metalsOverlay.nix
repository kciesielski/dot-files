{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.2.0+13-615add64-SNAPSHOT";
  outputHash = "sha256-9ctRngrQfRQgfHTfxkT70pLm5FYs719rs2/wGjt2Io8=";
}
