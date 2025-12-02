-- ~/.config/nvim/lua/plugins/nvim-tree.lua

return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- For file icons
        },
        config = function()
            -- Disable netrw (recommended by nvim-tree)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree").setup({
                sort_by = "case_sensitive",
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                    highlight_git = true,
                    add_trailing = false,
                },
                filters = {
                    dotfiles = false,
                },
                git = {
                    enable = true,
                    ignore = false,
                },
            })

            -- Set up gruvbox colors for nvim-tree
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                    -- Customize these colors to match gruvbox
                    vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#d5c4a1" })
                    vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#fabd2f" })
                    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#ebdbb2" })
                    vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#665c54" })
                    vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = "#fe8019" })
                    vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = "#b8bb26" })
                    vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = "#fb4934" })
                    vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = "#83a598" })
                    vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = "#b8bb26" })
                    vim.api.nvim_set_hl(0, "NvimTreeImageFile", { fg = "#d3869b" })
                end,
            })

            -- Key mappings for nvim-tree
            vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true, desc = "Toggle NvimTree" })
            vim.keymap.set('n', '<leader>e', ':NvimTreeFocus<CR>', { silent = true, desc = "Focus NvimTree" })
        end,
    },
}
