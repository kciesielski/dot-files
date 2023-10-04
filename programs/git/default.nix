{ pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "kciesielski";
    userEmail = "kciesielski@users.noreply.github.com";
    extraConfig = {
      merge = { conflictStyle = "diff3"; };
      core = {
        editor = "vim";
        pager = "diff-so-fancy | less -FXRi";
      };
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_rsa.pub";      
      color = { ui = true; };
      push = { default = "simple"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "main"; };
      alias = { gone = "!bash ~/bin/git-gone.sh"; };
      submodule = { recurse = true; };
    };
    ignores = [
      "*.bloop"
      "*.bsp"
      "*.metals"
      "*.metals.sbt"
      "*metals.sbt"
      "*.direnv"
      "*.envrc" # there is lorri, nix-direnv & simple direnv; let people decide
      "*hie.yaml" # ghcide files
      "*.mill-version" # used by metals
      "*.jvmopts" # should be local to every project
    ];
    includes = [
      {
        condition = "gitdir:~/dev/";
        contents = {
          user = {
            name = "Krzysztof Ciesielski";
          };
        };
      }
    ];
  };
}
