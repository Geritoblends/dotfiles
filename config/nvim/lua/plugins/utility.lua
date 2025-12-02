-- ~/.config/nvim/lua/plugins/utility.lua

return {
    -- Comment.nvim
    {
        'numToStr/Comment.nvim',
        opts = {
            -- hey
        }
    },

    -- Conform (Formatter)
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                -- Existing filetypes:
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                sh = {},
                rust = { "rustfmt" },

                -- ADDITIONS FOR HTML, CSS, TSX, and JSX:
                html = { "prettier" }, -- For HTML files
                css = { "prettier" },  -- For CSS files
                -- TSX is typically covered by 'typescriptreact' (already present)
                -- JSX is typically covered by 'javascriptreact' (already present)
            },
            format_on_save = function(bufnr)
                if vim.bo[bufnr].filetype == "sh" then
                    return -- skip formatting completely for shell scripts
                end
                return { lsp_fallback = true, timeout_ms = 500 }
            end,
        },
    },

    -- Smear Cursor
    {
        "sphamba/smear-cursor.nvim",
        opts = {
            smear_between_buffers = true,
            smear_between_neighbor_lines = true,
            scroll_buffer_space = true,
            legacy_computing_symbols_support = false,
            smear_insert_mode = true,
        },
    },

    -- Noice (Better messages)
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },

    -- Lualine (Statusline - commented out, but added for completeness)
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    --     config = function()
    --         require('lualine').setup({
    --             options = {
    --                 icons_enabled = true,
    --                 theme = 'auto',
    --                 component_separators = { left = '', right = '' },
    --                 section_separators = { left = '', right = '' },
    --                 disabled_filetypes = { statusline = {}, winbar = {} },
    --                 ignore_focus = {},
    --                 always_divide_middle = true,
    --                 always_show_tabline = true,
    --                 globalstatus = false,
    --                 refresh = { statusline = 100, tabline = 100, winbar = 100 }
    --             },
    --             sections = {
    --                 lualine_a = { 'mode' },
    --                 lualine_b = { 'branch', 'diff', 'diagnostics' },
    --                 lualine_c = { 'filename' },
    --                 lualine_x = { 'encoding', 'fileformat', 'filetype' },
    --                 lualine_y = { 'progress' },
    --                 lualine_z = { 'location' }
    --             },
    --             inactive_sections = {
    --                 lualine_a = {}, lualine_b = {},
    --                 lualine_c = { 'filename' },
    --                 lualine_x = { 'location' },
    --                 lualine_y = {}, lualine_z = {}
    --             },
    --             tabline = {}, winbar = {}, inactive_winbar = {}, extensions = {}
    --         })
    --     end,
    -- },
}
