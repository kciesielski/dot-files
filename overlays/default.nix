{ nixGL, ts-build }:
self: super:
let
  # Import unstable channel.
  # $ sudo nix-channel --add http://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
  # $ sudo nix-channel --update nixpkgs-unstable
  # nixPkgsUnstable = import <nixpkgs-unstable> { };
in
{
  alacritty = import ./alacritty.nix { inherit nixGL; pkgs = super; };
  # scala-cli = nixPkgsUnstable.scala-cli;
  metals = import ./metalsOverlay.nix {
    pkgs = super;
  };
  tree-sitter-scala-master =
    import ./treesitter-scala.nix { pkgs = super; };
  nvim-treesitter-textobjects =
    import ./nvim-treesitter-textobjects.nix { pkgs = super; };
}
