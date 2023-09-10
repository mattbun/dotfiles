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

  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = "auto",
          component_separators = { "", "" },
          section_separators = { "", "" },
          disabled_filetypes = {},
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      })
    end,
  })

  use({
    "AndrewRadev/switch.vim",
    setup = function()
      vim.g.switch_mapping = "-"
      vim.g.switch_custom_definitions = {
        { "!=", "==" },
        { "'", '"' },
        { "-", "_" },
        { "0", "1" },
        {
          _type = "normalized_case_words",
          _definition = { "on", "off" },
        },
        {
          _type = "normalized_case_words",
          _definition = { "yes", "no" },
        },
      }
    end,
  })

  use({
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local gitsigns = require("gitsigns")

      vim.cmd([[highlight GitSignsAdd guibg=#00000000]])
      vim.cmd([[highlight GitSignsChange guibg=#00000000]])
      vim.cmd([[highlight GitSignsDelete guibg=#00000000]])
      vim.cmd([[highlight GitsignsPopup guibg=#00000000]])

      gitsigns.setup({
        signs = {
          add = {
            hl = "GitSignsAdd",
            text = "+",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn",
          },
          change = {
            hl = "GitSignsChange",
            text = "~",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
          delete = {
            hl = "GitSignsDelete",
            text = "_",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          topdelete = {
            hl = "GitSignsDelete",
            text = "‾",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          changedelete = {
            hl = "GitSignsChange",
            text = "≃",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
        },
        current_line_blame_opts = {
          delay = 0,
        },
      })
    end,
  })

  use({
    "kyazdani42/nvim-tree.lua",
    config = function()
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
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
