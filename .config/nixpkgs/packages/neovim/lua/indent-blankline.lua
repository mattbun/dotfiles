local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowGreen",
  "RainbowCyan",
  "RainbowBlue",
  "RainbowViolet",
}

local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = vim.g.base16_red, ctermfg = "red" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = vim.g.base16_yellow, ctermfg = "yellow" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = vim.g.base16_green, ctermfg = "green" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = vim.g.base16_cyan, ctermfg = "cyan" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = vim.g.base16_blue, ctermfg = "blue" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = vim.g.base16_magenta, ctermfg = "magenta" })
end)

require("ibl").setup({
  indent = {
    highlight = highlight,
  },
  enabled = false, -- disable by default
})
