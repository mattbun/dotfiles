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
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

return require("packer").startup(function(use)
  -- Let packer update itself
  use("wbthomason/packer.nvim")

  use("editorconfig/editorconfig-vim")
  use("tpope/vim-eunuch")
  use("AndrewRadev/linediff.vim")
  use("ellisonleao/glow.nvim")

  use({
    "b3nj5m1n/kommentary",
    config = function()
      require("kommentary.config").configure_language("default", {
        prefer_single_line_comments = true,
      })
    end,
  })

  use({
    "jghauser/mkdir.nvim",
  })

  use({
    "williamboman/nvim-lsp-installer",
    requires = {
      "neovim/nvim-lspconfig",
    },
    after = "nvim-cmp",
    config = function()
      local lsp_installer = require("nvim-lsp-installer")

      lsp_installer.on_server_ready(function(server)
        -- All lsps get this option
        local opts = {
          capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        }

        -- Settings specific to certain lsps
        if server.name == "tsserver" then
          -- disable tsserver's formatting in favor of prettier
          opts.on_attach = function(client)
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
          end
        end

        -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
        server:setup(opts)
        vim.cmd([[ do User LspAttachBuffers ]])
      end)
    end,
  })

  -- TODO handle prettier in different places, like node_modules
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/116#issuecomment-899608031
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
          require("null-ls").builtins.formatting.prettierd.with({
            condition = function(utils)
              return utils.root_has_file(".prettierrc")
            end,
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
        { "0", "1" },
        { "ON", "OFF" },
        { "'", '"' },
        { "GET", "POST", "PUT", "DELETE", "PATCH" },
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
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("gitlinker").setup({
        -- TODO setting this to nil like the documentation says doesn't disable it
        mappings = "<leader>abcdef",
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

  use("LnL7/vim-nix")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
