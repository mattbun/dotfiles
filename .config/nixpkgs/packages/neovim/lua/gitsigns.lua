local gitsigns = require("gitsigns")

local none = "NONE"
local highlights = {
  GitSignsAdd = { fg = vim.g.base16_added, bg = none },
  GitSignsAddLn = { link = "GitSignsAdd" },
  GitSignsAddNr = { link = "GitSignsAdd" },
  GitSignsChange = { fg = vim.g.base16_changed, bg = none },
  GitSignsChangeLn = { link = "GitSignsChange" },
  GitSignsChangeNr = { link = "GitSignsChange" },
  GitSignsChangedelete = { fg = vim.g.base16_deleted, bg = none },
  GitSignsChangedeleteLn = { link = "GitSignsChangeDelete" },
  GitSignsChangedeleteNr = { link = "GitSignsChangeDelete" },
  GitSignsDelete = { fg = vim.g.base16_deleted, bg = none },
  GitSignsDeleteLn = { link = "GitSignsDelete" },
  GitSignsDeleteNr = { link = "GitSignsDelete" },
  GitSignsTopdelete = { fg = vim.g.base16_deleted, bg = none },
  GitSignsTopdeleteLn = { link = "GitSignsTopDelete" },
  GitSignsTopdeleteNr = { link = "GitSignsTopDelete" },
  GitSignsUntracked = { fg = vim.g.base16_untracked, bg = none },
  GitSignsUntrackedLn = { link = "GitSignsUntracked" },
  GitSignsUntrackedNr = { link = "GitSignsUntracked" },

  GitSignsStagedAdd = { link = "GitSignsAdd" },
  GitSignsStagedAddLn = { link = "GitSignsStagedAdd" },
  GitSignsStagedAddNr = { link = "GitSignsStagedAdd" },
  GitSignsStagedChange = { link = "GitSignsChange" },
  GitSignsStagedChangeLn = { link = "GitSignsStagedChange" },
  GitSignsStagedChangeNr = { link = "GitSignsStagedChange" },
  GitSignsStagedChangedelete = { link = "GitSignsDelete" },
  GitSignsStagedChangedeleteLn = { link = "GitSignsStagedChangeDelete" },
  GitSignsStagedChangedeleteNr = { link = "GitSignsStagedChangeDelete" },
  GitSignsStagedDelete = { link = "GitSignsDelete" },
  GitSignsStagedDeleteLn = { link = "GitSignsStagedDelete" },
  GitSignsStagedDeleteNr = { link = "GitSignsStagedDelete" },
  GitSignsStagedTopdelete = { link = "GitSignsDelete" },
  GitSignsStagedTopdeleteLn = { link = "GitSignsStagedTopDelete" },
  GitSignsStagedTopdeleteNr = { link = "GitSignsStagedTopDelete" },
}

for name, colorScheme in pairs(highlights) do
  vim.api.nvim_set_hl(0, name, colorScheme)
end

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
