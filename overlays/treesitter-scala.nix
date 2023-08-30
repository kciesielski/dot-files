{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "d50b6ca5cc3d925e3d1f497199cb8d8383ddae8a";
  src = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-scala";
    rev = version;
    hash = "sha256-SRj4iF1qS2jEFaIkRfXzAmzG7jKeSzKv5/GdXKbKRjU=";
  };
}
