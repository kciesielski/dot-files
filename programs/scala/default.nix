{ pkgs, config, ... }:
let
  unstable = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/cfd6b5fc90b15709b780a5a1619695a88505a176.tar.gz";
      sha256 = "0jd6x1qaggxklah856zx86dxwy4j17swv4df52njcn3ln410bic8";
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
