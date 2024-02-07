{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "45b5ba0e749a8477a8fd2666f082f352859bdc3c";
  src = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-scala";
    rev = version;
    hash = "sha256-tH2STGmCaVHDL4fOh8whPmiHbwKu8ZxjS4wDt+qVjjs=";
  };
}
