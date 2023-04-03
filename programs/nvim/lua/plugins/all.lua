
-- globals
local api = vim.api
local cmd = vim.cmd
local map = vim.keymap.set
local lsp = vim.lsp
local global_opt = vim.opt_global
local diag = vim.diagnostic
local spell_check_enabled = false

-- for nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
-- end special settings for nvim-tree

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function mapB(mode, l, r, desc)
        local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
        map(mode, l, r, opts)
    end
    -- Mappings.

    mapB("n", "<leader>rn", lsp.buf.rename, "lsp rename")
    mapB("n", "<leader>gD", lsp.buf.declaration, "lsp goto declaration")
    mapB("n", "<leader>gd", telescope_builtin.lsp_definitions, "lsp goto definition")
    mapB("n", "<leader>gi", telescope_builtin.lsp_implementations, "lsp goto implementation")
    mapB("n", "<leader>f", lsp.buf.format, "lsp format")
    mapB("n", "<leader>gs", telescope_builtin.lsp_document_symbols, "lsp document symbols")
    mapB(
        "n",
        "<Leader>gws",
        telescope_builtin.lsp_dynamic_workspace_symbols,
        "lsp workspace symbols"
    )
    mapB("n", "<leader>ca", lsp.buf.code_action, "lsp code action")

    mapB("n", "K", lsp.buf.hover, "lsp hover")
    mapB("n", "<Leader>gr", telescope_builtin.lsp_references, "lsp references")
    mapB("n", "<leader>sh", lsp.buf.signature_help, "lsp signature")

    local nndiag = next_integrations.diagnostic()
    mapB("n", "[d", nndiag.goto_prev({ wrap = false, severity = { min = diag.severity.WARN } }), "previous diagnostic")
    mapB("n", "]d", nndiag.goto_next({ wrap = false, severity = { min = diag.severity.WARN } }), "next diagnostic")

    if client.server_capabilities.documentFormattingProvider then
        cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
            ]])
    end
end

return {
    { 'lukas-reineke/indent-blankline.nvim' },
    { 'windwp/nvim-autopairs',
	config = function()
		require('nvim-autopairs').setup()
	end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },
    { 'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
        sources = {
            null_ls.builtins.formatting.shfmt,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.code_actions.eslint,
            null_ls.builtins.diagnostics.cspell.with({
                -- Force the severity to be HINT
                diagnostics_postprocess = function(diagnostic)
                    diagnostic.severity = diag.severity.HINT
                end,
            }),
            null_ls.builtins.code_actions.cspell,
            null_ls.builtins.code_actions.statix,
            null_ls.builtins.diagnostics.statix,
        },
        on_attach = function(client, bufnr)
            local function mapB(mode, l, r, desc)
                local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
                map(mode, l, r, opts)
            end

            -- local nndiag = next_integrations.diagnostic()
            on_attach(client, bufnr)
            -- mapB("n", "[s", nndiag.goto_prev({ wrap = false, severity = diag.severity.HINT }), "previous misspelled word")
            -- mapB("n", "]s", nndiag.goto_next({ wrap = false, severity = diag.severity.HINT }), "next misspelled word")
        end,
        })
        if not spell_check_enabled then
            null_ls.disable({ name = "cspell" })
        end
        map("n", "<leader>ss", function()
            if spell_check_enabled then
                null_ls.disable({ name = "cspell" })
                spell_check_enabled = false
            else
                null_ls.enable({ name = "cspell" })
                spell_check_enabled = true
            end
        end, { desc = "toggle spell check", noremap = true })
    end
    },
    { "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- local nngs = next_integrations.gitsigns(gs)
                    -- Navigation
                    -- map('n', ']c', nngs.next_hunk, { expr = true, desc = "next change" })
                    -- map('n', '[c', nngs.prev_hunk, { expr = true, desc = "previous change" })

                    -- Actions
                    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
                    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
                    map('n', '<leader>hS', gs.stage_buffer, { desc = "git:stage buffer" })
                    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "git:undo stage hunk" })
                    map('n', '<leader>hR', gs.reset_buffer, { desc = "git:reset buffer" })
                    map('n', '<leader>hp', gs.preview_hunk, { desc = "git:preview hunk" })
                    map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "git:toggle blame" })
                    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "git:current line blame" })
                    map('n', '<leader>hd', gs.diffthis, { desc = "git:show diff" })
                    map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "git:show diff~" })
                    map('n', '<leader>td', gs.toggle_deleted, { desc = "git:toggle deleted" })

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end,
            })
        end,
    },
    { "nvim-tree/nvim-tree.lua",
        config = function()
            local nvim_tree = require("nvim-tree")
            nvim_tree.setup({
                view = {
                    adaptive_size = true,
                },
            })
            local opts = { noremap = true, silent = true}
            map('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', { desc = "nvim tree toggle" }, opts)
        end,
        keys = { "<leader>tt" },
    },
    { "nvim-tree/nvim-web-devicons" },
    { "sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    { "mbbill/undotree" },
    { "TimUntersberger/neogit", 
    dependencies = { 'sindrets/diffview.nvim' },
        config = function()
		local neogit = require('neogit')
		neogit.setup {
		    disable_commit_confirmation = true,
		    integrations = {
		        diffview = true
		    }
		}
	end,
	keys = { { "<leader>99", "<cmd>Neogit<cr>" } }
    }


}
