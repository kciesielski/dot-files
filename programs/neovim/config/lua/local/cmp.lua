local setup = function()
    -- luasnip setup
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    -- nvim-cmp setup
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    local compare = require('cmp.config.compare')
    local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol_text",
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                symbol_map = { Copilot = "" }
            }),
        },
        mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<S-CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
            ["<Tab>"] = vim.schedule_wrap(function(fallback)
                if cmp.visible() and has_words_before() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end),
            ["<S-Tab>"] = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
        },
        sources = {
            { name = "copilot",  group_index = 2 },
            { name = "nvim_lsp", group_index = 2 },
            { name = "buffer",   group_index = 2 },
            { name = "luasnip",  group_index = 2 },
            { name = 'tmux',     group_index = 2 },
            { name = "path" },
        },
        preselect = cmp.PreselectMode.None, -- disable preselection
        sorting = {
            priority_weight = 2,
            comparators = {
                require("copilot_cmp.comparators").prioritize,
                compare.offset,    -- we still want offset to be higher to order after 3rd letter
                compare.exact,
                compare.score,     -- same as above
                compare.recently_used,
                compare.locality,
                compare.sort_text, -- add higher precedence for sort_text, it must be above `kind`
                compare.kind,
                compare.length,
                compare.order,
            },
        },
        -- if you want to add preselection you have to set completeopt to new values
        completion = {
            -- completeopt = 'menu,menuone,noselect', <---- this is default value,
            completeopt = 'menu,menuone', -- remove noselect
        },
    })
    return cmp
end

return { setup = setup }
