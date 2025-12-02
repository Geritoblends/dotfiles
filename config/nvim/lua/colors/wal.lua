local M = {}

function M.setup()
    local hl = vim.api.nvim_set_hl

    -- 1. Read the Pywal JSON file
    local wal_file = os.getenv("HOME") .. "/.cache/wal/colors.json"
    local f = io.open(wal_file, "r")

    -- Fallback colors in case file is missing (prevents crash)
    local palette = {
        bg = "NONE",
        fg = "#ffffff",
        red = "#ff0000",
        green = "#00ff00",
        yellow = "#ffff00",
        blue = "#0000ff",
        purple = "#ff00ff",
        aqua = "#00ffff",
        orange = "#ff8800",
        gray = "#888888",
        dark_gray = "#222222",
        selection = "#444444" -- Fallback selection
    }

    if f then
        local content = f:read("*all")
        f:close()
        -- Parse the JSON
        local wal = vim.json.decode(content)

        -- 💡 SMART LOGIC: Auto-detect Light vs Dark mode
        -- This fixes the "thin fonts" issue on light themes
        local bg_hex = wal.special.background:gsub("#", "")
        local r = tonumber(bg_hex:sub(1, 2), 16) or 0
        local g = tonumber(bg_hex:sub(3, 4), 16) or 0
        local b = tonumber(bg_hex:sub(5, 6), 16) or 0

        if (r + g + b) > 380 then
            vim.opt.background = "light"
        else
            vim.opt.background = "dark"
        end

        -- 2. Map Pywal colors (color0-15) to your semantic names
        palette = {
            bg = "NONE", -- Transparent background
            fg = wal.special.foreground,

            -- Standard ANSI mapping
            red = wal.colors.color1,
            green = wal.colors.color2,
            yellow = wal.colors.color3,
            blue = wal.colors.color4,
            purple = wal.colors.color5,
            aqua = wal.colors.color6,

            -- Bright/Other mappings
            gray = wal.colors.color8,      -- Bright Black
            orange = wal.colors.color9,    -- Bright Red
            dark_gray = wal.colors.color0, -- Dark background shade

            -- 🛠 FIX: Dedicated Selection Color
            -- color8 is "Bright Black". In dark themes, this is usually a visible gray.
            -- If you want it colored, change this to wal.colors.color2 (Green) etc.
            selection = wal.colors.color8,

            -- Extra variable for floating windows if you want them opaque
            float_bg = wal.special.background
        }
    end

    -- =================================================================
    -- HIGHLIGHT GROUPS
    -- =================================================================

    -- Base
    hl(0, "Normal", { fg = palette.fg, bg = palette.bg })
    hl(0, "NormalNC", { fg = palette.fg, bg = palette.bg })
    hl(0, "LineNr", { fg = palette.gray, bg = palette.bg })

    -- Cursor Line
    hl(0, "CursorLine", { bg = palette.bg })
    hl(0, "CursorLineNr", { fg = palette.yellow, bold = true, bg = palette.bg })

    -- 🛠 FIX: Use the new visible selection color
    hl(0, "Visual", { bg = palette.selection, fg = palette.fg, bold = true })

    hl(0, "SignColumn", { bg = palette.bg })
    hl(0, "StatusLine", { fg = palette.fg, bg = palette.bg })
    hl(0, "StatusLineNC", { fg = palette.gray, bg = palette.bg })
    hl(0, "VertSplit", { fg = palette.dark_gray, bg = palette.bg })

    -- Float/Popup windows
    hl(0, "NormalFloat", { fg = palette.fg, bg = palette.float_bg })
    hl(0, "FloatBorder", { fg = palette.gray, bg = palette.float_bg })

    -- Treesitter and Syntax
    hl(0, "Comment", { fg = palette.gray, italic = true })
    hl(0, "Keyword", { fg = palette.purple })
    hl(0, "Function", { fg = palette.green })
    hl(0, "String", { fg = palette.aqua })
    hl(0, "Constant", { fg = palette.orange })
    hl(0, "Type", { fg = palette.blue })
    hl(0, "Identifier", { fg = palette.yellow })
    hl(0, "Number", { fg = palette.orange })

    -- Lualine background
    hl(0, "lualine_a_normal", { fg = palette.yellow, bg = palette.bg, bold = true })
    hl(0, "lualine_a_insert", { fg = palette.blue, bg = palette.bg, bold = true })
    hl(0, "lualine_a_visual", { fg = palette.purple, bg = palette.bg, bold = true })
    hl(0, "lualine_b_normal", { fg = palette.green, bg = palette.bg })
    hl(0, "lualine_c_normal", { fg = palette.fg, bg = palette.bg })
    hl(0, "lualine_x_normal", { fg = palette.aqua, bg = palette.bg })
    hl(0, "lualine_z_normal", { fg = palette.orange, bg = palette.bg })

    -- Inactive buffers
    hl(0, "lualine_c_inactive", { fg = palette.gray, bg = palette.bg })
    hl(0, "lualine_x_inactive", { fg = palette.gray, bg = palette.bg })

    -- Diagnostics
    hl(0, "lualine_diagnostics_error_normal", { fg = palette.red, bg = palette.bg })
    hl(0, "lualine_diagnostics_warn_normal", { fg = palette.orange, bg = palette.bg })

    -- Optional terminal background
    hl(0, "TermCursor", { reverse = true })
end

return M
