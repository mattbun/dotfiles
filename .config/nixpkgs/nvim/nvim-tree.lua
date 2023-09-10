require("nvim-tree").setup({
  renderer = {
    icons = {
      show = {
        git = false,
        file = false,
        folder = true,
        folder_arrow = false,
      },
      glyphs = {
        folder = {
          arrow_open = "▾",
          arrow_closed = "▸",
          default = "▸",
          empty = "▸",
          empty_open = "▾",
          open = "▾",
          symlink = "▸",
          symlink_open = "▾",
        },
      },
    },
  },
})
