local formatter = require("formatter")

formatter.setup({
  logging = true,
  log_level = vim.log.levels.WARN,

  lua = {
    require("formatter.filetypes.lua").stylua,
  },

  markdown = {
    require("formatter.filetypes.markdown").prettierd,
  },

  ["*"] = {
    require("formatter.filetypes.any").remove_trailing_whitespace,
  },
})
