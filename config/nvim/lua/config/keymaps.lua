-- ~/.config/nvim/lua/config/keymaps.lua

-- Basic Keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save File" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit Buffer" })

-- Window Movement (Using C-w standard)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window Right" })

-- Window Resizing
vim.keymap.set("n", "<A-h>", "<C-W>5<", { silent = true, noremap = false, desc = "Resize Window Left" })
vim.keymap.set("n", "<A-l>", "<C-W>5>", { silent = true, noremap = false, desc = "Resize Window Right" })

-- Run Code Mappings
vim.keymap.set("n", "<leader>rp", ":w<CR>:!poetry run python %<CR>",
  { noremap = true, silent = false, desc = "Run Python (Poetry)" })
vim.keymap.set("n", "<leader>rr", ":w<CR>:!Rscript %<CR>", { noremap = true, silent = false, desc = "Run Rscript" })
vim.keymap.set("n", "<leader>rg", ":w<CR>:!go run %<CR>", { noremap = true, silent = false, desc = "Run Go" })
vim.keymap.set("n", "<leader>rty", ":!typora %<CR>", { desc = "Open in Typora" })
vim.keymap.set("n", "<leader>cw", ":colorscheme wal<CR>", { noremap = true, silent = false, desc = "Change Colorscheme" })

-- Editing Utilities
vim.keymap.set("n", "<leader>nh", ":noh<CR>", { noremap = true, silent = false, desc = "Clear Search Highlight" })
vim.keymap.set("n", "<leader>sv", ":vsp<CR>", { noremap = true, silent = false, desc = "Split Vertical" })
vim.keymap.set("n", "<leader>pa", "\"apA", { noremap = true, silent = false, desc = "Paste After Word" })
vim.keymap.set("n", "<S-k>", "kdd", { noremap = true, silent = false, desc = "Delete Line Up" }) -- This mapping seems unusual, you may want 'ddk'
vim.keymap.set("n", "<A-k>", "O<Esc>j", { desc = "Insert empty line above" })
vim.keymap.set("n", "<A-j>", "o<Esc>k", { desc = "Insert empty line below" })
