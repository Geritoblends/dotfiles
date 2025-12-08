-- 1. Standard Colorscheme Boilerplate
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "wal"

local hl = vim.api.nvim_set_hl

-- 2. Read the Pywal JSON file
local wal_file = os.getenv("HOME") .. "/.cache/wal/colors.json"
local f = io.open(wal_file, "r")

-- Fallback colors (prevents crash if cache is empty)
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
  selection = "#444444",
  float_bg = "#222222"
}

if f then
  local content = f:read("*all")
  f:close()

  -- Parse JSON safely
  local ok, wal = pcall(vim.json.decode, content)

  if ok and wal then
    -- 💡 SMART LOGIC: Auto-detect Light vs Dark mode
    local bg_hex = wal.special.background:gsub("#", "")
    local r = tonumber(bg_hex:sub(1, 2), 16) or 0
    local g = tonumber(bg_hex:sub(3, 4), 16) or 0
    local b = tonumber(bg_hex:sub(5, 6), 16) or 0

    if (r + g + b) > 380 then
      vim.opt.background = "light"
    else
      vim.opt.background = "dark"
    end

    -- Map Pywal colors
    palette = {
      bg = "NONE",
      fg = wal.special.foreground,
      red = wal.colors.color1,
      green = wal.colors.color2,
      yellow = wal.colors.color3,
      blue = wal.colors.color4,
      purple = wal.colors.color5,
      aqua = wal.colors.color6,

      gray = wal.colors.color8,
      orange = wal.colors.color9,
      dark_gray = wal.colors.color0,

      -- Use color8 for selection (visible grey) or choose another
      selection = wal.colors.color8,
      float_bg = wal.special.background
    }
  end
end

-- =================================================================
-- HIGHLIGHT GROUPS
-- =================================================================

-- Base
hl(0, "Normal", { fg = palette.fg, bg = palette.bg })
hl(0, "NormalNC", { fg = palette.fg, bg = palette.bg })
hl(0, "LineNr", { fg = palette.gray, bg = palette.bg })

-- Cursor
hl(0, "CursorLine", { bg = palette.bg })
hl(0, "CursorLineNr", { fg = palette.yellow, bold = true, bg = palette.bg })
hl(0, "Visual", { bg = palette.selection, fg = palette.fg, bold = true })
hl(0, "TermCursor", { reverse = true })

-- UI Elements
hl(0, "SignColumn", { bg = palette.bg })
hl(0, "StatusLine", { fg = palette.fg, bg = palette.bg })
hl(0, "StatusLineNC", { fg = palette.gray, bg = palette.bg })
hl(0, "VertSplit", { fg = palette.dark_gray, bg = palette.bg })
hl(0, "WinSeparator", { fg = palette.dark_gray, bg = palette.bg })

-- Floating Windows
hl(0, "NormalFloat", { fg = palette.fg, bg = palette.float_bg })
hl(0, "FloatBorder", { fg = palette.gray, bg = palette.float_bg })

-- Syntax
hl(0, "Comment", { fg = palette.gray, italic = true })
hl(0, "Keyword", { fg = palette.purple })
hl(0, "Function", { fg = palette.green })
hl(0, "String", { fg = palette.aqua })
hl(0, "Constant", { fg = palette.orange })
hl(0, "Type", { fg = palette.blue })
hl(0, "Identifier", { fg = palette.yellow })
hl(0, "Number", { fg = palette.orange })
hl(0, "PreProc", { fg = palette.red })
hl(0, "Special", { fg = palette.orange })

-- Lualine support
hl(0, "lualine_a_normal", { fg = palette.yellow, bg = palette.bg, bold = true })
hl(0, "lualine_b_normal", { fg = palette.green, bg = palette.bg })
hl(0, "lualine_c_normal", { fg = palette.fg, bg = palette.bg })
hl(0, "lualine_x_normal", { fg = palette.aqua, bg = palette.bg })
hl(0, "lualine_z_normal", { fg = palette.orange, bg = palette.bg })
hl(0, "lualine_c_inactive", { fg = palette.gray, bg = palette.bg })
