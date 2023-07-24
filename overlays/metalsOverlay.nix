{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  version = "1.0.0";
  outputHash = "sha256-futBxdMEJN0UdDvlk5FLUUmcG7r7P7D81IhbC2oYn5s=";
}
