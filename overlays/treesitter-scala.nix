{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "70b4fe63c4973b04cc7bd40c6b7646d9c2430db8";
  src = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-scala";
    rev = version;
    hash = "sha256-ZwrsEhlZGVJMP+GRIlaxGqS1b7HtiQelg3QBwJT9Igk=";
  };
}
