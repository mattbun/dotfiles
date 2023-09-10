-- Set up packer if it's not already installed
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

-- Run PackerCompile on changes to this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup(function(use)
  -- Let packer update itself
  use("wbthomason/packer.nvim")

  use({
    "williamboman/mason.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
    },
    after = "nvim-cmp",
    run = function()
      require("mason.api.command").MasonUpdate()
    end,
    config = function()
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
    end,
  })

  use({
    "ray-x/lsp_signature.nvim",
    config = function()
      local lspsignature = require("lsp_signature")
      lspsignature.setup({
        floating_window = false,
        hint_prefix = "",
        hint_enable = true,
      })
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
