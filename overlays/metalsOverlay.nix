{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.2.2+90-8e975366-SNAPSHOT";
  outputHash = "sha256-70wBDhUbsXwmtAK0IBdy/UNhkBkRkP8N9mQIc7AkMpQ=";
}
