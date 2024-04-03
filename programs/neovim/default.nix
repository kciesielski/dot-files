{ pkgs, config, ... }:
let
  leaderKey = "\\<Space>";
  unstable = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/d8fe5e6c92d0d190646fb9f1056741a229980089.tar.gz";
      sha256 = "0jd6x1qaggxklah856zx86dxwy4j17swv4df52njcn3ln410bic8";
    })
    {
      system = pkgs.system;
    };
  unstablePkgs = pkgs // { neovim = unstable.neovim-unwrapped; };
in
{
  home.file."./.config/nvim/" = {
    source = ./config;
    recursive = true;
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = unstable.neovim-unwrapped;
    extraConfig = ''
      	let mapleader = "${leaderKey}"
    '' +
    "${builtins.readFile ./init.vim}" +
    ''
      lua << EOF
        local tsserver_path = "${unstablePkgs.nodePackages.typescript-language-server}/bin/typescript-language-server"
        local typescript_path = "${unstablePkgs.nodePackages.typescript}/lib/node_modules/typescript/lib"
        local metals_binary_path = "${unstablePkgs.metals}/bin/metals"
        ${builtins.readFile ./init.lua}
      EOF
    '';
    extraPackages = with unstablePkgs; [
      pkgs.nodePackages.typescript
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.vim-language-server
      pkgs.nodePackages.yaml-language-server
      pkgs.rnix-lsp
      pkgs.sumneko-lua-language-server
      pkgs.stylua
      pkgs.shfmt
      pkgs.nodePackages.eslint
      pkgs.nodePackages.prettier
      pkgs.nodePackages.cspell
      pkgs.rust-analyzer
      pkgs.rustfmt
    ];
    plugins = with unstablePkgs.vimPlugins; [
      rec {
        plugin = catppuccin-nvim;
        config = ''
          packadd! ${plugin.pname}
          colorscheme catppuccin-macchiato
        '';
      }
      {
        plugin = telescope-nvim;
      }
      telescope-fzf-native-nvim
      {
        plugin = vim-tmux-navigator;
        config = ''
          nnoremap <silent> <A-Left> :TmuxNavigateLeft<cr>
          nnoremap <silent> <A-Down> :TmuxNavigateDown<cr>
          nnoremap <silent> <A-Up> :TmuxNavigateUp<cr>
          nnoremap <silent> <A-Right> :TmuxNavigateRight<cr>
        '';
      }
      auto-save-nvim
      which-key-nvim
      nvim-autopairs
      {
        plugin = vim-sandwich;
        #config = ''
        #  runtime macros/sandwich/keymap/surround.vim
        #'';
      }
      gitsigns-nvim
      plenary-nvim
      oil-nvim
      # completions
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-tmux
      cmp_luasnip

      # lsp stuff
      nvim-lspconfig
      null-ls-nvim

      (nvim-treesitter.withPlugins (
        # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars
        plugins:
          with plugins; [
            tree-sitter-lua
            tree-sitter-vim
            tree-sitter-html
            tree-sitter-yaml
            tree-sitter-json
            tree-sitter-markdown
            tree-sitter-markdown-inline
            tree-sitter-comment
            tree-sitter-bash
            tree-sitter-javascript
            tree-sitter-nix
            tree-sitter-typescript
            tree-sitter-c
            tree-sitter-java
            pkgs.tree-sitter-scala-master
            tree-sitter-query # for the tree-sitter itself
            tree-sitter-python
            tree-sitter-go
            tree-sitter-hocon
            tree-sitter-sql
            tree-sitter-graphql
            tree-sitter-dockerfile
            tree-sitter-scheme
            tree-sitter-rust
          ]
      ))
      playground
      nvim-treesitter-textobjects
      nvim-treesitter-refactor
      nvim-web-devicons
      lualine-nvim
      nvim-navic
      comment-nvim

      # snippets
      luasnip
      lspkind-nvim
      friendly-snippets
      fugitive
      p_nvim-errorlens
      nvim-neoclip-lua
      indent-blankline-nvim
      vim-tmux-clipboard
      telescope-ui-select-nvim
      noice-nvim
      nui-nvim
      fidget-nvim
      nvim-lightbulb
      p_nvim-next
      neoscroll-nvim
      neogit
      undotree
      vim-illuminate
      p_nvim-navbuddy
      diffview-nvim
      goto-preview
      p_nvim-neotree
      p_nvim-copilot
      p_nvim-hbac # Heuristic buffer auto-close
      nvim-ts-context-commentstring # context-aware comment strings
      nvim-dap
      {
        plugin = nvim-dap-ui;
        config = ''
          lua << EOF
            require("dapui").setup()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.event_terminated["dapui_config"] = function()
              dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
              dapui.close()
            end
          EOF
        '';
      }
      telescope-dap-nvim
      p_nvim-metals
      p_nvim-tmux-resize
      p_nvim-telescope-livegrep-args
      trouble-nvim
      gitlinker-nvim
      p_nvim-actions-preview
      {
        plugin = p_nvim-portal;
        config = ''
          lua << EOF
            vim.keymap.set("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
            vim.keymap.set("n", "<leader>i", "<cmd>Portal jumplist forward<cr>")
          EOF
        '';
      }
      {
        plugin = nvim-dap-virtual-text;
        config = ''
          lua <<EOF
            require("nvim-dap-virtual-text").setup()
          EOF
        '';
      }
      nvim-bqf
      {
        plugin = telescope-undo-nvim;
        config = ''
          lua <<EOF
            require("telescope").load_extension("undo")
            vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
          EOF
        '';
      }
      {
        plugin = dial-nvim;
        config = ''
          lua << EOF
            local augend = require("dial.augend")
            require("dial.config").augends:register_group{
              -- default augends used when no group name is specified
              default = {
                augend.integer.alias.decimal,   -- nonnegative decimal number (0, 1, 2, 3, ...)
                augend.integer.alias.hex,       -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                augend.constant.alias.bool,    -- boolean value (true <-> false)
              },
            }
            vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), {noremap = true})
            vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), {noremap = true})
            vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), {noremap = true})
            vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), {noremap = true})
            vim.keymap.set("v", "g<C-a>",require("dial.map").inc_gvisual(), {noremap = true})
            vim.keymap.set("v", "g<C-x>",require("dial.map").dec_gvisual(), {noremap = true})
          EOF
        '';
      }
      p_nvim-spider
      p_nvim-lsp-inlayhints
      p_nvim-copilot-cmp # adds copilot suggestions to completions
      p_nvim-copilot-chat
    ];
  };
}
