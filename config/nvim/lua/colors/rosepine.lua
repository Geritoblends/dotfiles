-- lua/colors/rosepine.lua

local M = {}

function M.setup()
    local hl = vim.api.nvim_set_hl
    local palette = {
        -- Rose Pine palette
        bg = "NONE",
        fg = "#e0def4",
        overlay = "#26233a",
        surface = "#1f1d2e",
        base = "#191724",
        muted = "#6e6a86",
        subtle = "#908caa",
        text = "#e0def4",
        love = "#eb6f92",
        gold = "#f6c177",
        rose = "#ebbcba",
        pine = "#31748f",
        foam = "#9ccfd8",
        iris = "#c4a7e7",
        highlight_low = "#21202e",
        highlight_med = "#403d52",
        highlight_high = "#524f67",
    }

    -- Base
    hl(0, "Normal", { fg = palette.fg, bg = palette.bg })
    hl(0, "NormalNC", { fg = palette.fg, bg = palette.bg })
    hl(0, "LineNr", { fg = palette.muted, bg = palette.bg })
    hl(0, "CursorLine", { bg = palette.highlight_low })
    hl(0, "CursorLineNr", { fg = palette.gold, bold = true, bg = palette.bg })
    hl(0, "Visual", { bg = palette.highlight_med })
    hl(0, "SignColumn", { bg = palette.bg })
    hl(0, "StatusLine", { fg = palette.text, bg = palette.bg })
    hl(0, "StatusLineNC", { fg = palette.muted, bg = palette.bg })
    hl(0, "VertSplit", { fg = palette.highlight_med, bg = palette.bg })

    -- Float/Popup windows
    hl(0, "NormalFloat", { fg = palette.text, bg = palette.overlay })
    hl(0, "FloatBorder", { fg = palette.subtle, bg = palette.overlay })

    -- Treesitter and Syntax
    hl(0, "Comment", { fg = palette.muted, italic = true })
    hl(0, "Keyword", { fg = palette.iris })
    hl(0, "Function", { fg = palette.rose })
    hl(0, "String", { fg = palette.foam })
    hl(0, "Constant", { fg = palette.gold })
    hl(0, "Type", { fg = palette.pine })
    hl(0, "Identifier", { fg = palette.rose })
    hl(0, "Number", { fg = palette.gold })

    -- Lualine background (set theme to auto in lualine)
    hl(0, "lualine_a_normal", { fg = palette.love, bg = palette.bg, bold = true })
    hl(0, "lualine_a_insert", { fg = palette.foam, bg = palette.bg, bold = true })
    hl(0, "lualine_a_visual", { fg = palette.iris, bg = palette.bg, bold = true })
    hl(0, "lualine_b_normal", { fg = palette.pine, bg = palette.bg }) -- Git branch
    hl(0, "lualine_c_normal", { fg = palette.text, bg = palette.bg }) -- Filename
    hl(0, "lualine_x_normal", { fg = palette.rose, bg = palette.bg }) -- Filetype
    hl(0, "lualine_z_normal", { fg = palette.gold, bg = palette.bg }) -- Location

    -- Inactive buffers
    hl(0, "lualine_c_inactive", { fg = palette.muted, bg = palette.bg })
    hl(0, "lualine_x_inactive", { fg = palette.muted, bg = palette.bg })

    -- Diagnostics
    hl(0, "lualine_diagnostics_error_normal", { fg = palette.love, bg = palette.bg })
    hl(0, "lualine_diagnostics_warn_normal", { fg = palette.gold, bg = palette.bg })

    -- Optional terminal background
    hl(0, "TermCursor", { reverse = true })
end

return M
