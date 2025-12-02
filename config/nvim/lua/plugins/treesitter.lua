-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            vim.cmd("TSUpdate")
        end,
        dependencies = {
            -- nvim-ts-autotag is moved here as a dependency to simplify logic
            "windwp/nvim-ts-autotag",
        },
        config = function()
            -- nvim-treesitter config
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "vim", "bash", "markdown", "python", "javascript", "typescript", "tsx", "html", "css" },
                highlight = { enable = true },
                indent = { enable = true },
            })

            -- nvim-ts-autotag config
            require('nvim-ts-autotag').setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = true
                    }
                }
            })
        end,
    },
}
