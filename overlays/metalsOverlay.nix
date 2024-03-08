{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.2.2+61-f2e80b9c-SNAPSHOT";
  outputHash = "sha256-9mAxnvHhyFetwPspNy6+/4fcjmXIzxyKfoxJtmhpxFE=";
}
