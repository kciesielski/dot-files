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
    enable_check_bracket_line = false,
    check_ts = true,
})


require("Comment").setup()

require("neoclip").setup()
require("telescope").load_extension("neoclip")
map("n", '<leader>"', require("telescope").extensions.neoclip.star, { desc = "clipboard" })

require("ibl").setup()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
require("local/neotree").setup()
require("copilot").setup({
    suggestion = { enabled = false, auto_trigger = false }, -- because we're using copilot-cmp
    panel = { enabled = false }
})
require("copilot_cmp").setup()
require("CopilotChat").setup()
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if #vim.fn.argv() == 0 then
            vim.defer_fn(function()
                -- Check if inside a git repository
                local is_inside_git_repo = os.execute("git rev-parse --is-inside-work-tree > /dev/null 2>&1")

                if is_inside_git_repo == 0 then
                    -- Now check if there are any modifications
                    local handle = io.popen("git status --porcelain")
                    local git_status_output = handle:read("*a")
                    handle:close()

                    if git_status_output ~= "" then
                        -- There are changes
                        vim.cmd("silent! lua require('telescope.builtin').git_status()")
                    else
                        -- No changes
                        vim.cmd("silent! lua require('telescope.builtin').find_files()")
                    end
                else
                    -- Not inside a git repo, so use find_files
                    vim.cmd("silent! lua require('telescope.builtin').find_files()")
                end
            end, 500)
        end
    end,
})
map("n", "<leader>ccq", function()
        local input = vim.fn.input("Ask Copilot: ")
        if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
    end,
    { desc = "CopilotChat - Quick chat" })
map("n", "<leader>ccd", "<cmd>CopilotChatFixDiagnostic<CR>", { desc = "Copilot Chat fix diag" })
map("n", "<leader>cp", "<cmd>CopilotChat<CR>", { desc = "Open Copilot Chat" })
