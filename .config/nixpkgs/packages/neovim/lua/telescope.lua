local telescope = require("telescope")

telescope.load_extension("fzf")
telescope.setup({
  disable_devicons = true,
  defaults = {
    preview = {
      treesitter = false,
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_cursor({}),
    },
  },
})

require("telescope").load_extension("ui-select")
