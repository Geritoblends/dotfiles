-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
-- Bootstrap lazy.nvim
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
-- Plugin setup with lazy.nvim
require("lazy").setup({
    -- {
    --     "Exafunction/windsurf.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "hrsh7th/nvim-cmp",
    --     },
    --     config = function()
    --         require("codeium").setup({
    --             virtual_text = {
    --                 enabled = true,
    --                 manual = false,
    --                 key_bindings = {
    --                     accept = "<M-i>",
    --                     accept_word = false,
    --                     accept_line = false,
    --                     next = "<M-j>",
    --                     prev = "<M-k>",
    --                     dismiss = "<M-u>",
    --                 },
    --             },
    --
    --
    --         })
    --     end
    -- },
    {
        'numToStr/Comment.nvim',
        opts = {
            -- hey
        }
    },

    -- nvim-tree file explorer
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
            vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
            vim.keymap.set('n', '<leader>e', ':NvimTreeFocus<CR>', { silent = true })
        end,
    },

    -- Essential plugins
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            vim.cmd("TSUpdate")
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "vim", "bash", "markdown", "python", "javascript", "typescript", "tsx", "html", "css" },
                highlight = { enable = true },
                indent = { enable = true },
            })
            require('nvim-ts-autotag').setup({
                opts = {
                    -- Defaults
                    enable_close = true,          -- Auto close tags
                    enable_rename = true,         -- Auto rename pairs of tags
                    enable_close_on_slash = false -- Auto close on trailing </
                },
                -- Also override individual filetype configs, these take priority.
                -- Empty by default, useful if one of the "opts" global settings
                -- doesn't work well in a specific filetype
                per_filetype = {
                    ["html"] = {
                        enable_close = true
                    }
                }
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "target/" },
                },
            })
            local telescope = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
            vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
            vim.keymap.set("n", "<leader>fb", telescope.buffers, {})
        end,
    },

    -- {
    --     "williamboman/mason-lspconfig.nvim",
    --     dependencies = {
    --         "williamboman/mason.nvim",
    --     },
    --     config = function()
    --         require("mason").setup({
    --             ui = {
    --                 icons = {
    --                     package_installed = "✓",
    --                     package_pending = "➜",
    --                     package_uninstalled = "✗",
    --                 },
    --             },
    --         })
    --
    --         require("mason-lspconfig").setup({
    --             ensure_installed = { "lua_ls", "pyright", "rust_analyzer" },
    --             automatic_installation = true,
    --         })
    --
    --         local on_attach = function(client, bufnr)
    --             local opts = { noremap = true, silent = true, buffer = bufnr }
    --             vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    --             vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    --             vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    --             vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    --             vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    --             vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    --             vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    --             vim.keymap.set("n", "<leader>f", function()
    --                 vim.lsp.buf.format { async = true }
    --             end, opts)
    --         end
    --
    --         -- lua_ls
    --         vim.lsp.config.lua_ls = {
    --             cmd = { "lua-language-server" },
    --             root_markers = {
    --                 ".luarc.json",
    --                 ".luarc.jsonc",
    --                 ".luacheckrc",
    --                 ".stylua.toml",
    --                 "stylua.toml",
    --                 "selene.toml",
    --                 "selene.yml",
    --             },
    --             on_attach = on_attach,
    --             settings = {
    --                 Lua = {
    --                     runtime = { version = "LuaJIT" },
    --                     diagnostics = { globals = { "vim" } },
    --                     workspace = {
    --                         library = vim.api.nvim_get_runtime_file("", true),
    --                         checkThirdParty = false,
    --                     },
    --                     telemetry = { enable = false },
    --                 },
    --             },
    --         }
    --
    --         -- pyright
    --         vim.lsp.config.pyright = {
    --             cmd = { "pyright-langserver", "--stdio" },
    --             root_markers = {
    --                 "pyproject.toml",
    --                 "setup.py",
    --                 "setup.cfg",
    --                 "requirements.txt",
    --                 "Pipfile",
    --                 "pyrightconfig.json",
    --             },
    --             on_attach = on_attach,
    --             settings = {
    --                 python = {
    --                     analysis = {
    --                         typeCheckingMode = "basic",
    --                         autoSearchPaths = true,
    --                         useLibraryCodeForTypes = true,
    --                     },
    --                 },
    --             },
    --         }
    --
    --         -- rust_analyzer
    --         vim.lsp.config.rust_analyzer = {
    --             cmd = { "rust-analyzer" },
    --             on_attach = on_attach,
    --             settings = {
    --                 ["rust-analyzer"] = {
    --                     cargo = { allFeatures = true },
    --                     checkOnSave = { command = "clippy" },
    --                     procMacro = { enable = true },
    --                 },
    --             },
    --         }
    --     end,
    -- },

    {
        'windwp/nvim-ts-autotag',
        config = function()
            require('nvim-ts-autotag').setup()
        end,
    },

    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                sh = {},
                rust = { "rustfmt" },
            },
            format_on_save = function(bufnr)
                if vim.bo[bufnr].filetype == "sh" then
                    return -- skip formatting completely for shell scripts
                end
                return { lsp_fallback = true, timeout_ms = 500 }
            end,
        },
    },
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
    --                 disabled_filetypes = {
    --                     statusline = {},
    --                     winbar = {},
    --                 },
    --                 ignore_focus = {},
    --                 always_divide_middle = true,
    --                 always_show_tabline = true,
    --                 globalstatus = false,
    --                 refresh = {
    --                     statusline = 100,
    --                     tabline = 100,
    --                     winbar = 100,
    --                 }
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
    --                 lualine_a = {},
    --                 lualine_b = {},
    --                 lualine_c = { 'filename' },
    --                 lualine_x = { 'location' },
    --                 lualine_y = {},
    --                 lualine_z = {}
    --             },
    --             tabline = {},
    --             winbar = {},
    --             inactive_winbar = {},
    --             extensions = {}
    --         })
    --     end,
    -- },
    {
        "sphamba/smear-cursor.nvim",

        opts = {
            -- Smear cursor when switching buffers or windows.
            smear_between_buffers = true,

            -- Smear cursor when moving within line or to neighbor lines.
            -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
            smear_between_neighbor_lines = true,

            -- Draw the smear in buffer space instead of screen space when scrolling
            scroll_buffer_space = true,

            -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
            -- Smears will blend better on all backgrounds.
            legacy_computing_symbols_support = false,
            smear_insert_mode = true,
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    {
        "e-ink-colorscheme/e-ink.nvim",
        priority = 1000,
        config = function ()
            require("e-ink").setup()
            vim.cmd.colorscheme "e-ink"

            -- choose light mode or dark mode
            vim.opt.background = "dark"
            -- vim.opt.background = "light"
            --
            -- or do
            -- :set background=dark
            -- :set background=light
        end
    },
})

-- Basic keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<leader>rp", ":w<CR>:!poetry run python %<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rr", ":w<CR>:!Rscript %<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rg", ":w<CR>:!go run %<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>nh", ":noh<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>sv", ":vsp<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>pa", "\"apA", { noremap = true, silent = false })
vim.keymap.set("n", "<S-k>", "kdd", { noremap = true, silent = false })
vim.keymap.set("n", "<A-k>", "O<Esc>j", { desc = "Insert empty line above" })
vim.keymap.set("n", "<A-j>", "o<Esc>k", { desc = "Insert empty line below" })
vim.keymap.set("n", "<leader>rty", ":!typora %<CR>", { desc = "Insert empty line below" })
vim.keymap.set("n", "<A-h>", "<C-W>5><CR<", { silent = true, noremap = false })
vim.keymap.set("n", "<A-l>", "<C-W>5<<CR>", { silent = true, noremap = false })

-- Add this to the end of your init.lua file

-- Make terminal split always appear at the bottom
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        -- Move the terminal to the bottom
        vim.cmd("wincmd J")
        -- Enter insert mode automatically (optional)
        vim.cmd("startinsert")
    end,
})

-- Create a custom command for convenience (optional)
vim.api.nvim_create_user_command("Terminal", function()
    vim.cmd("split")
    vim.cmd("terminal")
end, {})

-- Optional keymap for quickly opening a terminal at the bottom
vim.keymap.set("n", "<leader>t", ":split | terminal<CR>", { silent = true })


-- Add this to your init.lua to make <Esc> exit terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        -- Local terminal mapping for <Esc>
        vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
    end,
})

-- require("colors.rosepine").setup()
