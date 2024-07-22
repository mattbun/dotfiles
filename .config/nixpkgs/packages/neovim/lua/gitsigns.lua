local gitsigns = require("gitsigns")

local none = "NONE"
local added = { fg = vim.g.base16_green, bg = none }
local untracked = { fg = vim.g.base16_yellow, bg = none }
local changed = { fg = vim.g.base16_blue, bg = none }
local removed = { fg = vim.g.base16_red, bg = none }

vim.api.nvim_set_hl(0, "GitSignsAdd", added)
vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "GitSignsAdd" })
vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignsAdd" })
vim.api.nvim_set_hl(0, "GitSignsChange", changed)
vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "GitSignsChange" })
vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChange" })
vim.api.nvim_set_hl(0, "GitSignsChangedelete", removed)
vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { link = "GitSignsChangeDelete" })
vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChangeDelete" })
vim.api.nvim_set_hl(0, "GitSignsDelete", removed)
vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "GitSignsDelete" })
vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDelete" })
vim.api.nvim_set_hl(0, "GitSignsTopdelete", removed)
vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { link = "GitSignsTopDelete" })
vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsTopDelete" })
vim.api.nvim_set_hl(0, "GitSignsUntracked", untracked)
vim.api.nvim_set_hl(0, "GitSignsUntrackedLn", { link = "GitSignsUntracked" })
vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { link = "GitSignsUntracked" })

vim.api.nvim_set_hl(0, "GitSignsStagedAdd", added)
vim.api.nvim_set_hl(0, "GitSignsStagedAddLn", { link = "GitSignsStagedAdd" })
vim.api.nvim_set_hl(0, "GitSignsStagedAddNr", { link = "GitSignsStagedAdd" })
vim.api.nvim_set_hl(0, "GitSignsStagedChange", changed)
vim.api.nvim_set_hl(0, "GitSignsStagedChangeLn", { link = "GitSignsStagedChange" })
vim.api.nvim_set_hl(0, "GitSignsStagedChangeNr", { link = "GitSignsStagedChange" })
vim.api.nvim_set_hl(0, "GitSignsStagedChangedelete", removed)
vim.api.nvim_set_hl(0, "GitSignsStagedChangedeleteLn", { link = "GitSignsStagedChangeDelete" })
vim.api.nvim_set_hl(0, "GitSignsStagedChangedeleteNr", { link = "GitSignsStagedChangeDelete" })
vim.api.nvim_set_hl(0, "GitSignsStagedDelete", removed)
vim.api.nvim_set_hl(0, "GitSignsStagedDeleteLn", { link = "GitSignsStagedDelete" })
vim.api.nvim_set_hl(0, "GitSignsStagedDeleteNr", { link = "GitSignsStagedDelete" })
vim.api.nvim_set_hl(0, "GitSignsStagedTopdelete", removed)
vim.api.nvim_set_hl(0, "GitSignsStagedTopdeleteLn", { link = "GitSignsStagedTopDelete" })
vim.api.nvim_set_hl(0, "GitSignsStagedTopdeleteNr", { link = "GitSignsStagedTopDelete" })

gitsigns.setup({
  signs = {
    add = {
      text = "+",
    },
    change = {
      text = "~",
    },
    delete = {
      text = "_",
    },
    topdelete = {
      text = "‾",
    },
    changedelete = {
      text = "≃",
    },
    untracked = {
      text = "*",
    },
  },
  signs_staged = {
    add = {
      text = "|",
    },
    change = {
      text = "|",
    },
    delete = {
      text = "|",
    },
    topdelete = {
      text = "|",
    },
    changedelete = {
      text = "|",
    },
  },
  signs_staged_enable = false, -- https://github.com/lewis6991/gitsigns.nvim/issues/929
  attach_to_untracked = true,
  current_line_blame_opts = {
    delay = 0,
  },
  preview_config = {
    border = vim.g.border_style,
  },
})
