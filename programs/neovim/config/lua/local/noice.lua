local setup = function(telescope)
    local noice = require("noice").setup({
        notify = {
            -- Noice can be used as `vim.notify` so you can route any notification like other messages
            -- Notification messages have their level and other properties set.
            -- event is always "notify" and kind can be any log level as a string
            -- The default routes will forward notifications to nvim-notify
            -- Benefit of using Noice for this is the routing and consistent history view
            enabled = true,
            view = "mini",
        },
        messages = {
            enabled = true,      -- enables the Noice messages UI
            view = "mini",       -- default view for messages
            view_error = "mini", -- view for errors
            view_warn = "mini",  -- view for warnings
        },
        lsp = {
            progress = {
                enabled = true,
                format = "lsp_progress",
                format_done = "lsp_progress_done",
                throttle = 1000 / 30, -- frequency to update lsp progress message
                view = "mini",
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                ["vim.lsp.util.stylize_markdown"] = false,
                ["cmp.entry.get_documentation"] = false,
            },
            hover = {
                enabled = true,
                silent = false, -- set to true to not show a message if hover is not available
                view = nil,     -- when nil, use defaults from documentation
                opts = {},      -- merged with defaults from documentation
            },
            signature = {
                enabled = true,
                auto_open = {
                    enabled = true,
                    trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
                    luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
                    throttle = 50,  -- Debounce lsp signature help request by 50ms
                },
                view = nil,         -- when nil, use defaults from documentation
                opts = {},          -- merged with defaults from documentation
            },
            message = {
                enabled = true,
                view = "notify",
                opts = {},
            },
            documentation = {
                view = "hover",
                opts = {
                    lang = "markdown",
                    replace = true,
                    render = "plain",
                    format = { "{message}" },
                    win_options = { concealcursor = "n", conceallevel = 3 },
                },
            },
        }
    })
    telescope.load_extension("noice")
    return noice
end

return { setup = setup }
