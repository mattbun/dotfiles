-- pumswitch returns popup_key if the popup menu is visible, otherwise returns not_popup_key.
local function pumswitch(popup_key, not_popup_key)
  return function()
    if vim.fn.pumvisible() == 1 then
      return popup_key
    else
      return not_popup_key
    end
  end
end

local mappings = {
  -- Unmap space so it can be used as leader
  [""] = {
    ["<Space>"] = "",
  },

  -- (c)ommand mode
  c = {
    -- Make arrows move, select, and cancel in wildmenu (like when tab completing a command like ':e')
    ["<up>"] = { pumswitch("<c-p>", "<up>"), { noremap = true, expr = true } },
    ["<down>"] = { pumswitch("<c-n>", "<down>"), { noremap = true, expr = true } },
    ["<left>"] = { pumswitch("<c-e>", "<left>"), { noremap = true, expr = true } },
    ["<right>"] = { pumswitch("<c-y>", "<right>"), { noremap = true, expr = true } },
  },

  -- (n)ormal mode
  n = {
    ["<leader><up>"] = function()
      vim.cmd("wincmd k")
    end,
    ["<leader><down>"] = function()
      vim.cmd("wincmd j")
    end,
    ["<leader><left>"] = function()
      vim.cmd("wincmd h")
    end,
    ["<leader><right>"] = function()
      vim.cmd("wincmd l")
    end,

    ["<leader>,"] = "gT",
    ["<leader>."] = "gt",

    ["<leader><leader>"] = require("telescope.builtin").find_files,
    ["<leader>["] = "<C-o>",
    ["<leader>]"] = "<C-i>",
    ["<leader>#"] = require("telescope.builtin").grep_string,
    ["<leader>*"] = require("telescope.builtin").grep_string,
    ["<leader>~"] = function()
      require("telescope.builtin").find_files({ cwd = "~" })
    end,
    ["<leader>`"] = require("nvim-tree.api").tree.toggle,
    ["<leader>/"] = require("telescope.builtin").live_grep,
    ["<leader>\\"] = require("telescope.builtin").resume,
    ["<leader>?"] = require("telescope.builtin").help_tags,
    ["<leader>a"] = require("telescope.builtin").lsp_code_actions,
    ["<leader>b"] = require("telescope.builtin").buffers,
    ["<leader>d"] = require("gitsigns").preview_hunk,
    ["<leader>f"] = vim.lsp.buf.format,
    ["<leader>F"] = function()
      vim.g.autoformat = not vim.g.autoformat
      if vim.g.autoformat then
        print("enabled format on write")
      else
        print("disabled format on write")
      end
    end,
    ["<leader>ga"] = require("gitsigns").stage_hunk,
    ["<leader>gb"] = require("gitsigns").toggle_current_line_blame,
    ["<leader>gd"] = require("gitsigns").preview_hunk,
    ["<leader>go"] = function()
      require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser })
    end,
    ["<leader>gO"] = function()
      require("gitlinker").get_repo_url({ action_callback = require("gitlinker.actions").open_in_browser })
    end,
    ["<leader>gu"] = require("gitsigns").reset_hunk,
    ["<leader>gy"] = function()
      require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").copy_to_clipboard })
    end,
    ["<leader>gY"] = function()
      require("gitlinker").get_repo_url({ action_callback = require("gitlinker.actions").copy_to_clipboard })
    end,
    ["<leader>h"] = require("telescope.builtin").oldfiles,
    ["<leader>i"] = vim.cmd.IBLToggle,
    ["<leader>la"] = require("telescope.builtin").lsp_code_actions,
    ["<leader>ld"] = require("telescope.builtin").lsp_definitions,
    ["<leader>lf"] = vim.lsp.buf.format,
    ["<leader>li"] = require("telescope.builtin").lsp_implementations,
    ["<leader>ln"] = vim.lsp.buf.rename,
    ["<leader>lr"] = require("telescope.builtin").lsp_references,
    ["<leader>ls"] = require("telescope.builtin").lsp_document_symbols,
    ["<leader>lS"] = require("telescope.builtin").lsp_workspace_symbols,
    ["<leader>lt"] = require("telescope.builtin").lsp_type_definitions,
    ["<leader>m"] = function()
      require("glow").execute({
        fargs = {
          vim.fn.expand("%"),
        },
      })
    end,
    ["<leader>n"] = vim.lsp.buf.rename,
    ["<leader>q"] = vim.lsp.buf.hover,
    ["<leader>s"] = vim.lsp.buf.signature_help,
    ["<leader>w"] = vim.diagnostic.open_float,
    ["<leader>W"] = require("telescope.builtin").diagnostics,
    ["<leader>u"] = require("gitsigns").reset_hunk,
    ["<leader>y"] = function()
      vim.fn.setreg("*", vim.fn.expand("%f"))
    end,

    -- `g`-based mappings are often already mapped, be careful adding new ones (use `:help gt`)
    ["gd"] = require("telescope.builtin").lsp_definitions,
  },

  -- (v)isual mode
  v = {
    ["<leader>f"] = vim.lsp.buf.format,
    ["<leader>go"] = function()
      require("gitlinker").get_buf_range_url("v", { action_callback = require("gitlinker.actions").open_in_browser })
    end,
    ["<leader>gy"] = function()
      require("gitlinker").get_buf_range_url("v", { action_callback = require("gitlinker.actions").copy_to_clipboard })
    end,
    ["<leader>lf"] = vim.lsp.buf.format,
  },
}

for mode, modeMappings in pairs(mappings) do
  for mapping, action in pairs(modeMappings) do
    if type(action) == "table" then
      vim.keymap.set(mode, mapping, action[1], action[2])
    else
      vim.keymap.set(mode, mapping, action, { noremap = true, silent = true })
    end
  end
end
