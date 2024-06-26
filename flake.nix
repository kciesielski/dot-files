{
  description = "Home Manager configuration of Krzysztof Ciesielski";

  inputs =
    {
      nix.url = "github:nixos/nix/2.20-maintenance";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

      home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixGL = {
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Neovim plugins
      p_nvim-actions-preview = {
        url = "github:aznhe21/actions-preview.nvim";
        flake = false;
      };
      p_nvim-copilot = {
        url = "github:zbirenbaum/copilot.lua";
        flake = false;
      };
      p_nvim-copilot-cmp = {
        url = "github:zbirenbaum/copilot-cmp";
        flake = false;
      };
      p_nvim-copilot-chat = {
        url = "github:CopilotC-Nvim/CopilotChat.nvim/canary";
        flake = false;
      };
      p_nvim-lsp-inlayhints = {
        url = "github:lvimuser/lsp-inlayhints.nvim";
        flake = false;
      };
      p_nvim-spider =
        {
          url = "github:chrisgrieser/nvim-spider";
          flake = false;
        };
      p_nvim-errorlens =
        {
          url = "github:chikko80/error-lens.nvim";
          flake = false;
        };
      p_nvim-hbac = {
        url = "github:axkirillov/hbac.nvim";
        flake = false;
      };
      p_nvim-leap = {
        url = "github:ggandor/leap.nvim";
        flake = false;
      };
      p_nvim-metals = {
        url = "github:scalameta/nvim-metals";
        flake = false;
      };
      p_nvim-next = {
        url = "github:ghostbuster91/nvim-next";
        flake = false;
      };
      p_nvim-navbuddy = {
        url = "github:SmiteshP/nvim-navbuddy";
        flake = false;
      };
      p_nvim-neotree = {
        url = "github:nvim-neo-tree/neo-tree.nvim/v3.x";
        flake = false;
      };
      p_nvim-portal = {
        url = "github:cbochs/portal.nvim";
        flake = false;
      };
      p_nvim-tmux-resize =
        {
          url = "github:RyanMillerC/better-vim-tmux-resizer";
          flake = false;
        };
      p_nvim-telescope-livegrep-args = {
        url = "github:nvim-telescope/telescope-live-grep-args.nvim";
        flake = false;
      };
    };

  outputs = inputs @ { home-manager, nixpkgs, nixGL, ... }:
    let
      system = "x86_64-linux";
      username = "kc";

      overlays = import ./overlays {
        inherit inputs;
      };

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (self: super: { derivations = import ./derivations { pkgs = super; inherit (nixpkgs) lib; }; })
          overlays
        ];
      };
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };

        modules = [
          ./home.nix
          {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              stateVersion = "23.11";
            };
          }
        ];
      };
    };
}
