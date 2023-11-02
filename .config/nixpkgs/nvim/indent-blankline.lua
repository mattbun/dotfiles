local highlight = {
  "RainbowRed",
  "RainbowOrange",
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
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#" .. vim.g.base16_gui08 })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#" .. vim.g.base16_gui09 })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#" .. vim.g.base16_gui0A })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#" .. vim.g.base16_gui0B })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#" .. vim.g.base16_gui0C })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#" .. vim.g.base16_gui0D })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#" .. vim.g.base16_gui0E })
end)

require("ibl").setup({
  indent = {
    highlight = highlight,
  },
  enabled = false, -- disable by default
})
