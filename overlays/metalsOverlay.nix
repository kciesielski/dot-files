{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.2.2+117-8cc7a42f-SNAPSHOT";
  outputHash = "sha256-8Wh56XvOw6/Y7vXEYgKpBlidMbRA5krOw3iBRyfYG2w=";
}
