{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  version = "0.11.12+105-8283260d-SNAPSHOT";
  outputHash = "sha256-TJKC1X+6/1aPhnfB5VuPMjGsmoTDEft9cv3y6++4kHA=";
}
