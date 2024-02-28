{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "e02f003d78dc269fef287b9b7b9963dc1f26bd7e";
  src = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-scala";
    rev = version;
    hash = "sha256-LkrZ+y7QSAGe/kkkdUSyFQJFmD/mOI5Ps/wxD3BAkDI=";
  };
}
