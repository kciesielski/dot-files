{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "b76db435a7f876cf1ede837d66054c534783c72f";
  src = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-scala";
    rev = version;
    hash = "sha256-AZ1YIsnw3x84T2ubwWoekfy98L2GdgQP0R3tM8DEXLM=";
  };
}
