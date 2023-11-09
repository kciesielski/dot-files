-- This file will be inlined into home-manager initial configuration
-- globals
local api = vim.api
local cmd = vim.cmd
local map = vim.keymap.set
local lsp = vim.lsp
local global_opt = vim.opt_global
local diag = vim.diagnostic

global_opt.clipboard = "unnamed"
global_opt.timeoutlen = 200

local next_integrations = require("nvim-next.integrations")

-- Saving files as root with w!! {
map("c", "w!!", "%!sudo tee > /dev/null %", { noremap = true })
-- }

-- <CTRL> + a and <CTRL> + e move to the beginning and the end of the line
map("c", "<C-a>", "<HOME>", { noremap = true })
map("c", "<C-e>", "<END>", { noremap = true })
-- }

map("n", "<F11>", ":wall<CR>", { noremap = true, silent = true })
map("i", "<F11>", "<ESC>:wall<CR>", { noremap = true, silent = true })
map("n", "<leader>su", function()
    diag.setqflist()
end, { desc = "Diagnostics into qflist" })
map("n", "<leader>se", function()
    diag.setqflist({ severity = "E" })
end, { desc = "Diagnostics[E] into qflist" })

local toggle_qf = function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd "cclose"
        return
    end
    vim.cmd "copen"
end
map("n", "<leader>to", toggle_qf, { desc = "qflist toggle" })


local navic = require("nvim-navic")

local hocon_group = api.nvim_create_augroup("hocon", { clear = true })
api.nvim_create_autocmd(
    { 'BufNewFile', 'BufRead' },
    { group = hocon_group, pattern = '*/resources/*.conf', command = 'set ft=hocon' }
)


require("which-key").setup()

require("nvim-autopairs").setup({
    check_ts = true,
})


require("Comment").setup()

require("neoclip").setup()
require("telescope").load_extension("neoclip")
map("n", '<leader>"', require("telescope").extensions.neoclip.star, { desc = "clipboard" })

require("ibl").setup()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function single_click_edit(node)
    vim.defer_fn(function()
        local win = vim.api.nvim_get_current_win()
        local view = require "nvim-tree.view"
        if view.get_winnr() ~= win then return end
        local actions = require 'nvim-tree.actions.dispatch'
        actions.dispatch("edit")
    end, 10)
end


require("nvim-tree").setup({
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "<LeftRelease>", action = "single_click_edit", action_cb = single_click_edit },
            }
        }
    }
})
map("n", '<leader>et', function()
    require("nvim-tree.api").tree.toggle(true, true)
end, { desc = "nvim_tree toggle" })
map("n", '<leader>ef', function()
    require("nvim-tree.api").tree.find_file(false, true)
end, { desc = "nvim_tree toggle" })

require("oil").setup({
    keymaps = {
        ["<C-v>"] = "actions.select_vsplit",
    },
}
)
map("n", '<leader>e-', function()
    require("oil").open()
end, { desc = "Open dir in oil" }
)

require("fidget").setup({
    debug = {
        logging = true
    }
})

require('nvim-lightbulb').setup({ autocmd = { enabled = true } })

local diffview_actions = next_integrations.diffview(require("diffview.actions"))
require("diffview").setup({
    file_history_panel = {
        keymaps = {
            { "n", "[x", diffview_actions.prev_conflict,
                {
                    desc =
                    "In the merge-tool: jump to the previous conflict"
                } },
            { "n", "]x", diffview_actions.next_conflict,
                {
                    desc =
                    "In the merge-tool: jump to the next conflict"
                } }
        }
    }
})

local neogit = require('neogit')
neogit.setup {
    disable_commit_confirmation = true,
    integrations = {
        diffview = true
    }
}
map("n", '<leader>n', function()
    neogit.open()
end, { desc = "neogit" })

require("error-lens").setup(client, {})
require('goto-preview').setup {
    default_mappings = true,
}



local virtual_text = false
diag.config({ virtual_text = virtual_text })
map("n", "<leader>jt", function()
    virtual_text = not virtual_text
    diag.config({ virtual_text = virtual_text })
end, { desc = "toggle virtual text" })
map("n", "=", function()
    diag.open_float()
end, { desc = "show diagnostic under the cursor" })

local nvim_next_builtins = require("nvim-next.builtins")
require("nvim-next").setup({
    default_mappings = {
        repeat_style = "directional",
    },
    items = {
        nvim_next_builtins.f,
        nvim_next_builtins.t
    }
})
local next_move = require("nvim-next.move")
local prev_qf_item, next_qf_item = next_move.make_repeatable_pair(function(_)
    local status, err = pcall(vim.cmd, "cprevious")
    if not status then
        vim.notify("No more items", vim.log.levels.INFO)
    end
end, function(_)
    local status, err = pcall(vim.cmd, "cnext")
    if not status then
        vim.notify("No more items", vim.log.levels.INFO)
    end
end)

map("n", "]q", next_qf_item, { desc = "nvim-next: next qfix" })
map("n", "[q", prev_qf_item, { desc = "nvim-next: prev qfix" })

require("spider").setup({
    skipInsignificantPunctuation = true
})
map("n", "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
map("n", "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
map("n", "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
map("n", "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
require("gitlinker").setup()
require("auto-save").setup({
    trigger_events = { "BufLeave" }
})
require("local/trouble").setup()
local telescope = require("local/telescope").setup()
require("local/noice").setup(telescope.core)
local navbuddy = require("nvim-navbuddy")
map("n", "<C-n>", "<cmd>Navbuddy<CR>", { desc = "Toggle Navbuddy" })
require("local/lsp").setup(telescope.core, telescope.builtin, navic, navbuddy, next_integrations, tsserver_path,
    typescript_path,
    metals_binary_path)
require("local/gitsigns").setup(next_integrations)
local luasnip = require("local/luasnip").setup()
require("local/cmp").setup()
require("local/lualine").setup(navic)
require("local/treesitter").setup(next_integrations)
require("local/neoscroll").setup()

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if #vim.fn.argv() == 0 then
            vim.defer_fn(function()
                vim.cmd("silent! lua require('telescope.builtin').find_files()")
            end, 500)
        end
    end,
})
