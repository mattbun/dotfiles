-- load colorscheme
vim.cmd("runtime colorscheme.vim")

-- show line numbers
vim.o.number = true

-- enable mouse in all modes
vim.o.mouse = "a"

-- auto-indent with the indent from the previous line
vim.o.ai = true

-- ignore case in searches
vim.o.ic = true

-- highlight search matches, hide them with `:noh`
vim.o.hls = true

-- allow unsaved changes to be hidden in buffers
vim.o.hidden = true

-- set leader to space
vim.g.mapleader = " "

-- display tabs as two spaces
vim.o.tabstop = 2

-- When indenting with autoindent or `>>`/`<<`, use the tabstop value for tab width
vim.o.shiftwidth = 0

-- use spaces instead of tabs by default (this can be overridden by an editorconfig)
vim.o.expandtab = true

-- but certain filetypes should always use tabs
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "go",
    "gomod",
    "make",
  },
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- don't add a newline at the end if it's missing
vim.o.fixendofline = false

-- show a guide line at 101 characters (the line is at the beginning of what's past 100 chars)
vim.o.colorcolumn = "101"

-- use system clipboard by default
vim.o.clipboard = "unnamedplus"

-- show substitutions
vim.o.inccommand = "nosplit"

-- set a global border style variable
vim.g.border_style = "rounded"

-- Rounded borders for hovers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = vim.g.border_style })

-- Disable LSP semantic tokens because...
-- * nix files look weird with it
-- * tsserver ends up changing the highlighting after it starts (which takes a second or two)
-- TODO it's probably worth enabling when it works better
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})
