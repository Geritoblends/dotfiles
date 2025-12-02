-- ~/.config/nvim/lua/plugins/telescope.lua

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "target/", "node_modules", "%.git/" },
                },
            })
            local telescope = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Live Grep" })
            vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "List Buffers" })
        end,
    },
}
