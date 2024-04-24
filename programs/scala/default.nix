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
  home.packages = with unstable; [
    openjdk21
    scala
    bloop
    scala-cli
    ammonite
    scalafmt
    coursier
    sbt
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk21}";
    JVM_DEBUG =
      "-J-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005";
  };

  programs.sbt = {
    enable = false;
    plugins =
      let
        projectGraph = {
          org = "com.dwijnand";
          artifact = "sbt-project-graph";
          version = "0.4.0";
        };
      in
      [
        projectGraph
        {
          org = "ch.epfl.scala";
          artifact = "sbt-bloop";
          inherit (unstable.bloop) version;
        }
      ];
  };
}
