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
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.stylua,
          require("null-ls").builtins.formatting.prettier.with({
            only_local = "node_modules/.bin",
          }),
        },
      })
    end,
  })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/vim-vsnip-integ",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
          ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "buffer" },
          { name = "emoji", insert = true },
          { name = "calc" },
          { name = "path" },
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

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    config = function()
      local telescope = require("telescope")

      telescope.load_extension("fzf")
      telescope.setup({
        disable_devicons = true,
      })
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
