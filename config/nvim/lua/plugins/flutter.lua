-- ~/.config/nvim/lua/plugins/flutter.lua

return {
    -- Flutter Tools for Debugging, Outline, Widgets, etc.
    {
        'akinsho/flutter-tools.nvim',
        name = 'flutter-tools',
        -- It's often set to lazy = false to ensure the DLS is available immediately
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'mfussenegger/nvim-dap',  -- Needed for Debugging
            'stevearc/dressing.nvim', -- Recommended for better UI elements (like device selection)
        },
        config = function()
            -- Merge your standard on_attach keymaps with flutter-tools features
            local flutter_on_attach = function(client, bufnr)
                -- 1. Call your standard LSP keymap function (assuming it's available)
                -- You may need to wrap your keymaps from lsp.lua into a function
                -- or just copy them here if they are only for lsp.lua.
                -- For simplicity, let's redefine the common ones here:
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts, { desc = "LSP Hover Documentation" })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts, { desc = "Go to Definition" })
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts, { desc = "LSP Code Action" })
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts, { desc = "LSP Rename" })
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format { async = true }
                end, opts, { desc = "LSP Format Buffer" })

                -- 2. Add Flutter-Tools specific keymaps
                vim.keymap.set('n', '<leader>fr', ':FlutterRun<CR>', opts, { desc = 'Flutter Run' })
                vim.keymap.set('n', '<leader>fq', ':FlutterQuit<CR>', opts, { desc = 'Flutter Quit' })
                vim.keymap.set('n', '<leader>fd', ':FlutterDevices<CR>', opts, { desc = 'Flutter Devices' })
                vim.keymap.set('n', '<leader>ft', ':FlutterTest<CR>', opts, { desc = 'Run Flutter Tests' })
            end

            require('flutter-tools').setup({
                lsp = {
                    -- Pass the merged on_attach function to flutter-tools
                    on_attach = flutter_on_attach,
                    -- Optional: Enable widget guides for better UI feedback
                    -- You may need to install the treesitter parser for this
                    widget_guides = {
                        enabled = true,
                    },
                },
                debugger = {
                    enabled = true,
                    register_for_dap = true, -- Auto-configure DAP for Flutter
                },
                -- Ensures the DLS can find the Flutter SDK
                -- Usually not needed if `flutter` is in your PATH
                -- flutter_path = 'path/to/your/flutter/bin/flutter',
            })
        end
    },
}
