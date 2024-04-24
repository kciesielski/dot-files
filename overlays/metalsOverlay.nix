{ pkgs }:
let
  metalsBuilder = import ./metalsBuilder.nix { inherit pkgs; };
in
metalsBuilder {
  # https://scalameta.org/metals/latests.json
  version = "1.3.0+34-275a42c2-SNAPSHOT";
  outputHash = "sha256-MgODZsYVQurSmd5P5fv1R5NvYkhHdET6falLLuaVYqQ=";
}
