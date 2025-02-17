{ pkgs, config, ... }:
let
  unstable = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/3144f2d9767aab834e57757f7edba53235ae39d2.tar.gz";
      sha256 = "0aw114hk7bxkm1k1fy5bi6widpkpwcly1aks9q3f3b1vgnykkqwm";
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
    scala-cli
    ammonite
    scalafmt
    coursier
    sbt
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk11}";
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
