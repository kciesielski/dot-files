{ pkgs, config, ... }:
let
  unstable = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/43129fa7763313ada48a0a12fd951f3f49a03d3e.tar.gz";
      sha256 = "0rgf6390c016nlyvp3kzalglzlr5p2blw3y7r67109jd4r6a7x9y";
    })
    {
      system = pkgs.system;
    };
  unstablePkgs = pkgs // { neovim = unstable.neovim-unwrapped; };
in
{
  programs.yazi = {
    enable = true;
    package = unstablePkgs.yazi;
  };
}
