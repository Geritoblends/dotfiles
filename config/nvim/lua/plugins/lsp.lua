-- ~/.config/nvim/lua/plugins/lsp.lua

-- 1. Define the standard LSP on_attach function
local on_attach = function(client, bufnr)
    -- Disable semantic capabilities for rust_analyzer as it causes performance issues
    if client.name == 'rust_analyzer' then
        client.server_capabilities.semanticTokensProvider = nil
    end

    -- Keymaps are defined with the buffer-local option 'bufnr'
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts, { desc = "LSP Hover Documentation" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts, { desc = "Go to Definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts, { desc = "Go to Declaration" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts, { desc = "Go to Implementation" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts, { desc = "Show References" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts, { desc = "LSP Code Action" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts, { desc = "LSP Rename" })
    vim.keymap.set("n", "<C-y>", vim.diagnostic.open_float, opts, { desc = "Show diagnostic error messages" })
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format { async = true }
    end, opts, { desc = "LSP Format Buffer" })
end

-- 2. Define the server-specific configurations
local lsp_servers = {
    lua_ls = {
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    },
    pyright = {
        on_attach = on_attach,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                },
            },
        },
    },
    rust_analyzer = {
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = true,
                procMacro = { enable = true },
            },
        },
    },
}

-- 3. Return the plugin specifications for lazy.nvim
return {
    -- Mason and LSP Setup
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            -- This plugin provides the 'lspconfig' module used below
            "neovim/nvim-lspconfig",
        },
        config = function()
            -- Mason Setup
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            -- Mason LSPConfig Setup
            -- This ensures the LSPs are installed and auto-configures them
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(lsp_servers), -- Use keys from the config table
                automatic_installation = true,
            })

            -- Setup nvim-lspconfig using your custom server configs
            -- This part uses the correct `require("lspconfig")` module, which is the modern approach
            -- The deprecated API involved calling setup directly on the module itself,
            -- not on the individual server definitions.
            for name, config in pairs(lsp_servers) do
                vim.lsp.config(name, config)
                vim.lsp.enable(name)
            end
        end,
    },

    -- AI Autocompletion (Codeium)
    {
        "Exafunction/windsurf.nvim",
        name = "codeium",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
                virtual_text = {
                    enabled = true,
                    manual = false,
                    key_bindings = {
                        accept = "<M-i>",
                        accept_word = false,
                        accept_line = false,
                        next = "<M-j>",
                        prev = "<M-k>",
                        dismiss = "<M-u>",
                    },
                },
            })
        end
    },
}
