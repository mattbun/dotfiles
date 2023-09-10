local gitsigns = require("gitsigns")

vim.cmd([[highlight GitSignsAdd guibg=#00000000]])
vim.cmd([[highlight GitSignsChange guibg=#00000000]])
vim.cmd([[highlight GitSignsDelete guibg=#00000000]])
vim.cmd([[highlight GitsignsPopup guibg=#00000000]])

gitsigns.setup({
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "+",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = "~",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "_",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "‾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "≃",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  current_line_blame_opts = {
    delay = 0,
  },
})
