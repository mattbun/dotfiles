require("mason").setup({
  PATH = "append", -- prefer packages installed via nix to work around nixos linking issues
})

require("mason-lspconfig").setup({
  ensure_installed = {},
})

-- This automatically sets up any new language servers that are installed
require("mason-lspconfig").setup_handlers({
  -- default handler
  function(server_name)
    require("lspconfig")[server_name].setup({})
  end,

  -- These are configured manually below
  ["lua_ls"] = function() end,
  ["rnix"] = function() end,
})

-- These language servers are installed via nix so mason doesn't need to manage them
local lspconfig = require("lspconfig")
lspconfig.rnix.setup({})
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
