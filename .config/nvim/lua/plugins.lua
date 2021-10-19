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
	use("b3nj5m1n/kommentary")
	use({
		"jghauser/mkdir.nvim",
		config = function()
			require("mkdir")
		end,
	})

	-- TODO only use prettier if there's a prettierrc

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
					capabilities = require("cmp_nvim_lsp").update_capabilities(
						vim.lsp.protocol.make_client_capabilities()
					),
				}

				-- Settings specific to certain lsps
				if server.name == "tsserver" then
					-- disable tsserver's formatting in favor of prettier
					opts.on_attach = function(client)
						client.resolved_capabilities.document_formatting = false
						client.resolved_capabilities.document_range_formatting = false
					end
				elseif server.name == "efm" then
					local prettier = {
						-- Only format if there's a .prettierrc and use prettierd because it's faster
						formatCommand = '(test -f .prettierrc && prettierd "${INPUT}") || cat "${INPUT}"',
						-- formatCommand = 'prettierd "${INPUT}"',
						formatStdin = true,
					}

					opts.init_options = { documentFormatting = true }
					opts.settings = {
						rootMarkers = { ".git/" },
						languages = {
							typescript = { prettier },
							javascript = { prettier },
							json = { prettier },
							yaml = { prettier },
						},
					}
				end

				-- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
				server:setup(opts)
				vim.cmd([[ do User LspAttachBuffers ]])
			end)
		end,
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("null-ls").config({
				sources = {
					require("null-ls").builtins.formatting.stylua,
					require("null-ls").builtins.formatting.prettierd,
				},
			})
			require("lspconfig")["null-ls"].setup({
				on_attach = my_custom_on_attach,
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
					["<CR>"] = cmp.mapping.confirm({ select = true }),
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
		"glepnir/lspsaga.nvim",
		requires = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			local saga = require("lspsaga")

			saga.init_lsp_saga({
				use_saga_diagnostic_sign = true,
				error_sign = "x",
				warn_sign = "!",
				hint_sign = "h",
				infor_sign = "i",
				finder_definition_icon = "",
				finder_reference_icon = "",
				code_action_icon = "$ ",
				dianostic_header_icon = "! ",
				definition_preview_icon = "",
				code_action_prompt = {
					enable = true,
					sign = false,
					sign_priority = 20,
					virtual_text = false,
				},
				code_action_keys = {
					quit = "<ESC>",
					exec = "<CR>",
				},
				finder_action_keys = {
					open = "<CR>",
					vsplit = "v",
					split = "h",
					quit = "<ESC>",
					scroll_down = "<C-f>",
					scroll_up = "<C-b>",
				},
				rename_action_keys = {
					quit = "<ESC>",
					exec = "<CR>",
				},
				rename_prompt_prefix = "Rename:",
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
		"hoob3rt/lualine.nvim",
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
					lualine_c = { "filename" },
					lualine_x = { "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
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
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			vim.g.nvim_tree_show_icons = {
				git = 0,
				folders = 0,
				files = 0,
				folder_arrows = 1,
			}
			require("nvim-tree").setup({})
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
