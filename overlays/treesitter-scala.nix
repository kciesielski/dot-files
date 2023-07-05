{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "scala";
  version = "bc9fb988bfc25fc727342882c8ac2e12e023979f";
  src = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-scala";
    rev = version;
    hash = "sha256-h6FVIwSw188pT6wLPMXjnkBQ9kEjFQbY/8fhJyKLeYA=";

  };
}
