{ pkgs, config, inputs, lib, ... }: {


  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "kc";
  # home.homeDirectory = "/home/kc";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file.".config/nix/registry.json".text = builtins.toJSON {
    flakes =
      lib.mapAttrsToList
        (n: v: {
          exact = true;
          from = {
            id = n;
            type = "indirect";
          };
          to = {
            path = v.outPath;
            type = "path";
          };
        })
        inputs;
    version = 2;
  };

  nix.package = inputs.nix.packages.${pkgs.system}.nix;
  nix.settings.nix-path = [
    "nixpkgs=${inputs.nixpkgs}"
    "home-manager=${inputs.home-manager}"
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  imports = [
    ./programs/scala
    ./programs/alacritty
    ./programs/vscode
    ./programs/tmux
    ./programs/zsh
    ./programs/git
  ];

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" "JetBrainsMono" ]; })
    diff-so-fancy # pretty diffs
    git-gone # get rid of orphan local branches
    bat # better cat
    tokei # better cloc
    xsv # csv manipulation
    fd # faster find
    ripgrep # better grep

    tree # display tree structure of directory
    jq # pretty-print json

    # Files
    dua # disk usage analyzer

    # nix stuff
    nix-du
    nix-index
    nixpkgs-review
    nix-tree
    nixfmt
    nix-prefetch
    nurl

    # Media
    youtube-dl

    # Overview
    htop
    neofetch

    xsel # for tmux-yank

    gh
    tig
    statix # nix linter

    kubectl

    # gnome stuff
    flameshot
  ];

  programs = {
    exa = {
      enable = true;
      enableAliases = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        unset LD_LIBRARY_PATH
      '';
    };
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org.gnome.desktop.input-sources" = {
        show-all-sources = "false";
        xkb-options = "['numpad:shift3', 'numpad:microsoft']";
        per-window = "false";
        current = "uint32 0";
        mru-sources = "@a(ss) []";
        sources = "[('xkb', 'pl')]";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
        {
          binding = "<Primary><Alt>f";
          command = "alacritty";
          name = "open-terminal";
        };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
        {
          binding = "<Print>";
          command = "flameshot gui";
          name = "flameshot screenshot";
        };
    };
  };

  services.redshift = {
    enable = true;
    latitude = "52.2370";
    longitude = "21.0175";
    temperature.night = 3000;
    temperature.day = 3000;
  };

  services.unclutter = {
    enable = true;
    extraOptions = [ "ignore-scrolling" ];
  };

  systemd.user.startServices = "sd-switch";
}
