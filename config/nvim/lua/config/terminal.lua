-- ~/.config/nvim/lua/config/terminal.lua

-- Custom Command
vim.api.nvim_create_user_command("Terminal", function()
    vim.cmd("split")
    vim.cmd("terminal")
end, { desc = "Open Terminal in Horizontal Split" })

-- Keymap
vim.keymap.set("n", "<leader>t", ":split | terminal<CR>", { silent = true, desc = "Split and Open Terminal" })

-- Autocmds for terminal behavior
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        -- Move the terminal to the bottom
        vim.cmd("wincmd J")
        -- Enter insert mode automatically (optional)
        vim.cmd("startinsert")
        -- Local terminal mapping for <Esc> to exit terminal mode
        vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
    end,
})
