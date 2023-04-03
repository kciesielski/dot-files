return {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'AckslD/nvim-neoclip.lua', ------- clipboard
        requires = {
            { 'nvim-telescope/telescope.nvim' },
        },
        config = function()
            require('neoclip').setup()
        end,},
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>tf", "<cmd>Telescope find_files<cr>" },
            { "<leader>tg", "<cmd>Telescope live_grep<cr>" },
            { "<leader>th", "<cmd>Telescope buffers<cr>" },
            { "<leader>/", "<cmd>Telescope commands<cr>" },
            { "<leader>gh", "<cmd>lua require('telescope.builtin').git_commits()<cr>", desc = "Telescope commits" },
            { '<leader>"', "<cmd>Telescope neoclip<cr>", desc = "Telescope neoclip" }, --- show clipboard
        },
        dependencies = { 'nvim-lua/plenary.nvim', 'AckslD/nvim-neoclip.lua', 'nvim-telescope/telescope-ui-select.nvim' },
        config = function()
            require('telescope').setup {
                extensions = {
                    fzf = {
                    fuzzy = true,                    -- false will only do exact matching
                    override_generic_sorter = true,  -- override the generic sorter
                    override_file_sorter = true,     -- override the file sorter
                    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                                    -- the default case_mode is "smart_case"
                    }
                }
            }
            require('telescope.builtin')
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('neoclip')
            require('telescope').load_extension('ui-select')
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make" -- doesn't really work?
    }
}
