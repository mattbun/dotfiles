-- Set diagnostic signs
local signs = {
  Error = "x",
  Warning = "!",
  Hint = "h",
  Information = "i",
}

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Set some options for diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Change some language server options when we attach them
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- disable semantic tokens, they look weird. TODO someday I'll hopefully fix this
    client.server_capabilities.semanticTokensProvider = nil

    -- disable tsserver's formatting in favor of prettier
    if client.name == "tsserver" then
      client.server_capabilities.documentFormattingProvider = nil
      client.server_capabilities.documentRangeFormattingProvider = nil
    end
  end,
})

-- Show diagnostics on hover
-- TODO this doesn't work so well if you're trying to show a definition (`gh`) on a line with a diagnostic
-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
-- vim.o.updatetime = 250
-- vim.cmd(
--   [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false,show_header=false}) end]]
-- )

-- Format on save by default but provide a variable to toggle it on and off
vim.g.autoformat = true

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  callback = function()
    if vim.g.autoformat then
      vim.lsp.buf.format()
    end
  end,
})
