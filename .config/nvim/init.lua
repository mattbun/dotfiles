vim.cmd([[
  source ~/.vimrc
]])

require("lsp")
require("plugins")
require("shortcuts")

-- show substitutions
vim.o.inccommand = "nosplit"

vim.cmd([[
  highlight SignColumn guibg=#00000000
  highlight LineNr guibg=#00000000
]])
