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

  home.file.".ssh/allowed_signers".text = "* ${builtins.readFile ./id_rsa.pub}";
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
  nixpkgs.config.permittedInsecurePackages = [
    "nix-2.15.3"
  ];

  nixpkgs.config.allowUnfree = true;
  nix.package = inputs.nix.packages.${pkgs.system}.nix;
  nix.settings.nix-path = [
    "nixpkgs=${inputs.nixpkgs}"
    "home-manager=${inputs.home-manager}"
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
  };

  imports = [
    ./programs/scala
    ./programs/alacritty
    ./programs/tmux
    ./programs/zsh
    ./programs/neovim
    ./programs/neofetch
    ./programs/git
    ./programs/yazi
  ];

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ### CLI utils
    bat # better cat
    ctop # Like k9s but for Docker
    diff-so-fancy # pretty diffs
    dua # disk usage analyzer
    eza # a for of exa, better ls
    fd # faster find, recursive, example: 'fd Main.scala'
    gh # GitHub utils
    git-gone # get rid of orphan local branches
    glow # terminal markdown viewer
    htop # system process manager
    jq # query and pretty-print json
    k9s # Kubernetes browser
    neofetch # rich system info
    ouch # compression and decompression
    p7zip # compression/decompression with reliable password protection
    ripgrep # better grep, 'rg'
    shell_gpt # ChatGPT CLI, 'sgpt'
    spotdl # download spotify tracks from YT 
    sysz # pretty interactive systemd viewer
    tig # nice git log with ASCII branches
    tokei # better cloc, lines of code, stats
    tree # display tree structure of directory
    xsel # Operate on clipboard, 'cat file | xsel -b' and 'xsel -b'
    xsv # csv manipulation
    # yazi - terminal file manager (yy to yank file, p to paste)
    ###
    flameshot # take screenshots in Gnome
    git-crypt # git files encryption
    gnome3.gnome-tweaks
    gnomeExtensions.paperwm
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    jhiccup
    nix-du
    nix-index
    nix-output-monitor
    nix-prefetch
    nix-tree
    nixfmt
    nixpkgs-review
    nodejs
    nurl
    peek # recording gifs from desktop, gnome only?
    rage # encryption tool for secrets management
    statix # nix linter
    kubectl
    youtube-dl
    calibre
    vscode
    yarn
  ];

  programs = {
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
          binding = "Print";
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
