require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.formatting.prettier.with({
      prefer_local = "node_modules/.bin",
    }),
  },
})
