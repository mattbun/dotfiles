-- Format on save by default but provide a variable to toggle it on and off
vim.g.autoformat = true

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  callback = function()
    if vim.g.autoformat then
      vim.lsp.buf.format({
        filter = function(client)
          -- Disable null-ls here because we'll only enable it in some cases
          return client.name ~= "null-ls"
        end,
      })
    end
  end,
})

-- Disable certain lsp formatters when we have better alternatives
local disabledLSPFormatters = {
  tsserver = true, -- prettier
  lua_ls = true, -- stylua
}
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil and disabledLSPFormatters[client.name] then
      client.server_capabilities.documentFormattingProvider = nil
      client.server_capabilities.documentRangeFormattingProvider = nil
    end
  end,
})

-- Format lua files with stylua
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*.lua",
  callback = function()
    if vim.g.autoformat then
      vim.lsp.buf.format({
        filter = function(client)
          return client.name == "null-ls"
        end,
      })
    end
  end,
})

-- Only use prettier if it's in the local node_modules
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = {
    -- This isn't an exhaustive list of filetypes that prettier will format. Here's a handy resource for finding file extensions:
    -- https://github.com/github-linguist/linguist/blob/master/lib/linguist/languages.yml
    "*.cjs",
    "*.cts",
    "*.gql",
    "*.graphql",
    "*.html",
    "*.js",
    "*.json",
    "*.jsx",
    "*.md",
    "*.mdx",
    "*.mjs",
    "*.mts",
    "*.ts",
    "*.tsx",
    "*.vue",
    "*.yaml",
    "*.yml",
  },
  callback = function()
    if vim.g.autoformat and vim.fn.filereadable("node_modules/.bin/prettier") == 1 then
      vim.lsp.buf.format({
        filter = function(client)
          return client.name == "null-ls"
        end,
      })
    end
  end,
})
