{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "f14629b4d53f72356ce8f6d4ac8c54d21b4e74dd";
  src = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-scala";
    rev = version;
    hash = "sha256-SRj4iF1qS2jEFaIkRfXzAmzG7jKeSzKv5/GdXKbKRjU=";
  };
}
