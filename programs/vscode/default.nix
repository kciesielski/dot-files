{ config, pkgs, lib, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = (
      with pkgs.vscode-extensions; [
        oderwat.indent-rainbow
        eamodio.gitlens
        edonet.vscode-command-runner
        scala-lang.scala
        file-icons.file-icons
        esbenp.prettier-vscode
        jnoortheen.nix-ide
        ms-python.python
        ms-vscode-remote.remote-ssh
        redhat.vscode-yaml
        shardulm94.trailing-spaces
        slevesque.vscode-multiclip
        tamasfe.even-better-toml
        timonwong.shellcheck
        tyriar.sort-lines
        yzhang.markdown-all-in-one
        zhuangtongfa.material-theme
      ]
    );
    keybindings = [
      {
        "key" = "ctrl+q";
        "command" = "-workbench.action.quit";
      }
      {
        "key" = "ctrl+q";
        "command" = "workbench.action.remote.close";
        "when" = "resourceScheme == 'vscode-remote'";
      }
      {
        "key" = "ctrl+q";
        "command" = "workbench.action.closeFolder";
        "when" = "resourceScheme != 'vscode-remote' && workbenchState != 'empty'";
      }
      {
        "key" = "ctrl+q";
        "command" = "workbench.action.closeWindow";
        "when" = "resourceScheme != 'vscode-remote' && workbenchState == 'empty'";
      }
    ];
    userSettings = {
      "editor.bracketPairColorization.enabled" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.inlayHints.enabled" = "off";
      "editor.minimap.enabled" = true;
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [ 80 120 ];
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "search.collapseResults" = "auto";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.automationProfile.linux" = {
        "path" = "bash";
        "icon" = "terminal-bash";
      };
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.profiles.linux" = {
        "zsh" = {
          "path" = "env";
          "args" = [
            "zsh"
          ];
        };
        "ash" = null;
        "sh" = null;
      };
      "update.mode" = "none";

      "workbench.colorTheme" = "One Dark Pro";
      "oneDarkPro.italic" = false;

      "workbench.commandPalette.preserveInput" = true;
      "workbench.editor.enablePreviewFromCodeNavigation" = true;
      "workbench.iconTheme" = "file-icons";

      "dev.containers.defaultExtensions" = [
        "Tyriar.sort-lines"
        "eamodio.gitlens"
        "shardulm94.trailing-spaces"
      ];
      "dev.containers.dockerComposePath" = lib.getExe pkgs.podman-compose;
      "dev.containers.dockerPath" = lib.getExe pkgs.podman;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${lib.getExe pkgs.nil}";
      "nix.serverSettings" = {
        nil.formatting.command = [ (lib.getExe pkgs.nixpkgs-fmt) ];
      };
    };
  };
}
