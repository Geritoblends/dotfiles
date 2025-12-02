-- ~/.config/nvim/init.lua

-- Define the bootstrap path for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core options and settings immediately
require("config.options")

-- Load all plugin specs using lazy.nvim
require("lazy").setup({
  require("plugins.lsp"),        -- LSP, Mason, Codeium (AI)
  require("plugins.nvim-tree"),
  require("plugins.treesitter"), -- Treesitter and Autotag
  require("plugins.telescope"),
  require("plugins.utility"),    -- Comment, Conform, Smear Cursor, Noice
  require("plugins.flutter"),
  require("plugins.osc"),
})

local osc52 = require('osc52')

vim.keymap.set('n', '<leader>c', osc52.copy_operator, { expr = true })
vim.keymap.set('v', '<leader>c', function()
  osc52.copy_visual()
end)

-- Load all keymaps and terminal setup *after* plugins
require("config.keymaps")
require("config.terminal")
require("colors.wal").setup()
