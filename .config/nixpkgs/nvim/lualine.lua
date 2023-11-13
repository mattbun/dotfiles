-- Based on https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/themes/base16.lua
local colors = {
  bg = vim.g.base16_gui01,
  alt_bg = vim.g.base16_gui02,
  dark_fg = vim.g.base16_gui03,
  fg = vim.g.base16_gui04,
  light_fg = vim.g.base16_gui05,
  normal = vim.g.base16_accent,
  insert = vim.g.base16_gui0B,
  visual = vim.g.base16_gui0D,
  replace = vim.g.base16_gui09,
  command = vim.g.base16_gui08,
}

local theme = {
  normal = {
    a = { fg = colors.bg, bg = colors.normal },
    b = { fg = colors.light_fg, bg = colors.alt_bg },
    c = { fg = colors.fg, bg = colors.bg },
  },
  replace = {
    a = { fg = colors.bg, bg = colors.replace },
    b = { fg = colors.light_fg, bg = colors.alt_bg },
  },
  insert = {
    a = { fg = colors.bg, bg = colors.insert },
    b = { fg = colors.light_fg, bg = colors.alt_bg },
  },
  visual = {
    a = { fg = colors.bg, bg = colors.visual },
    b = { fg = colors.light_fg, bg = colors.alt_bg },
  },
  command = {
    a = { fg = colors.bg, bg = colors.command },
    b = { fg = colors.light_fg, bg = colors.alt_bg },
  },
  inactive = {
    a = { fg = colors.dark_fg, bg = colors.bg },
    b = { fg = colors.dark_fg, bg = colors.bg },
    c = { fg = colors.dark_fg, bg = colors.bg },
  },
}

theme.command = theme.normal
theme.terminal = theme.insert

require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = theme,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "branch" },
    lualine_b = {
      {
        "filename",
        path = 1,
        symbols = {
          readonly = "[RO]",
        },
      },
    },
    lualine_c = { "diff", "diagnostics" },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "progress" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = {},
    lualine_b = {
      {
        "tabs",
        mode = 1, -- Show tab name but not number
        max_length = vim.o.columns,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = {},
})

-- Only show tabline if there's more than one tab
vim.cmd("set showtabline=1")
