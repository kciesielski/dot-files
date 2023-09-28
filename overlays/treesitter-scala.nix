{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "d72cdd40329207af482950cb8a004da10d5a8126";
  src = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-scala";
    rev = version;
    hash = "sha256-N0VjibXwcsqZEZrm4kZFT/sB8f6NnjP62QhpcwgzA1w=";
  };
}
