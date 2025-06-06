require("mason").setup({
  PATH = "append", -- prefer packages installed via nix to work around nixos linking issues
  ui = {
    border = vim.g.border_style,
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {},
})

-- extend neovim's LSP capabilities with the ones from cmp.nvim
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

-- This automatically sets up any new language servers that are installed
require("mason-lspconfig").setup_handlers({
  -- default handler
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
    })
  end,

  ["gopls"] = function()
    require("lspconfig").gopls.setup({
      capabilities = capabilities,
      settings = {
        gopls = {
          experimentalPostfixCompletions = true,
        },
      },
    })
  end,

  -- These are configured manually below
  ["lua_ls"] = function() end,
  ["nil_ls"] = function() end,
})

-- These language servers are installed via nix so mason doesn't need to manage them
local lspconfig = require("lspconfig")
lspconfig.nil_ls.setup({
  capabilities = capabilities,
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
require("lspconfig").lua_ls.setup({
  capabilities = capabilities,
  on_init = function(client)
    -- Don't use neovim config if there's a .luarc.json
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths here.
          "${3rd}/luv/library",
          -- "${3rd}/busted/library",
        },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        -- library = vim.api.nvim_get_runtime_file("", true)
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
