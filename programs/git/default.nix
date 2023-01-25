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
      color = { ui = true; };
      push = { default = "simple"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "main"; };
      alias = { gone = "!bash ~/bin/git-gone.sh"; };
      submodule = { recurse = true; };
    };
    includes = [
      {
        condition = "gitdir:~/dev/";
        contents = {
          user = {
            name = "Krzysztof Ciesielski";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
  };
}
