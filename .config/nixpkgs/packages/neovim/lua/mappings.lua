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

local wk = require("which-key")
wk.setup({
  preset = "helix",
  icons = {
    mappings = false,
  },
})

local wkMappings = {
  -- (c)ommand mode
  c = {
    -- TODO these don't work in which-key for whatever reason
    -- Make arrows move, select, and cancel in wildmenu (like when tab completing a command like ':e')
    -- { "<up>", desc = "move up", pumswitch("<c-p>", "<up>"), noremap = true, expr = true },
    -- { "<down>", desc = "move down", pumswitch("<c-n>", "<down>"), noremap = true, expr = true },
    -- { "<left>", desc = "cancel", pumswitch("<c-e>", "<left>"), noremap = true, expr = true },
    -- { "<right>", desc = "select", pumswitch("<c-y>", "<right>"), noremap = true, expr = true },
  },

  -- (n)ormal mode
  n = {
    {
      "<leader><up>",
      desc = "Go to the up window",
      function()
        vim.cmd("wincmd k")
      end,
    },
    {
      "<leader><down>",
      desc = "Go to the down window",
      function()
        vim.cmd("wincmd j")
      end,
    },
    {
      "<leader><left>",
      desc = "Go to the left window",
      function()
        vim.cmd("wincmd h")
      end,
    },
    {
      "<leader><right>",
      desc = "Go to the right window",
      function()
        vim.cmd("wincmd l")
      end,
    },

    {
      "<leader><S-Up>",
      desc = "Move window up",

      function()
        vim.cmd("wincmd K")
      end,
    },
    {
      "<leader><s-down>",
      desc = "Move window down",
      function()
        vim.cmd("wincmd J")
      end,
    },
    {
      "<leader><s-left>",
      desc = "Move window left",
      function()
        vim.cmd("wincmd H")
      end,
    },
    {
      "<leader><s-right>",
      desc = "Move window right",
      function()
        vim.cmd("wincmd L")
      end,
    },

    { "<leader>,", desc = "Go to previous tab page", "gT" },
    { "<leader>.", desc = "Go to next tab page", "gt" },
    { "<leader><leader>", desc = "Find file", require("telescope.builtin").find_files },
    { "<leader>[", desc = "Previous buffer", "<C-o>" },
    { "<leader>]", desc = "Next buffer", "<C-i>" },
    { "<leader>*", desc = "Search workspace for word (reverse)", require("telescope.builtin").grep_string },
    { "<leader>#", desc = "Search workspace for word", require("telescope.builtin").grep_string },
    {
      "<leader>~",
      desc = "Find file in ~",
      function()
        require("telescope.builtin").find_files({ cwd = "~" })
      end,
    },
    { "<leader>`", desc = "Toggle tree", require("nvim-tree.api").tree.toggle },
    { "<leader>/", desc = "Search workspace", require("telescope.builtin").live_grep },
    { "<leader>\\", desc = "Resume search", require("telescope.builtin").resume },
    { "<leader>?", desc = "Search help", require("telescope.builtin").help_tags },
    { "<leader>a", desc = "LSP code actions", vim.lsp.buf.code_action },
    { "<leader>b", desc = "Buffers", require("telescope.builtin").buffers },

    { "<leader>c", group = "CodeCompanion" },
    { "<leader>ca", desc = "actions", require("codecompanion").actions },
    {
      "<leader>cc",
      desc = "prompt",
      function()
        vim.cmd("CodeCompanion")
      end,
    },
    {
      "<leader>cd",
      desc = "explain diagnostic",
      function()
        vim.cmd("CodeCompanion /lsp")
      end,
    },
    {
      "<leader>ce",
      desc = "explain",
      function()
        vim.cmd("CodeCompanion /explain")
      end,
    },
    {
      "<leader>cf",
      desc = "fix",
      function()
        vim.cmd("CodeCompanion /fix")
      end,
    },
    {
      "<leader>ct",
      desc = "write unit tests",
      function()
        vim.cmd("CodeCompanion /tests")
      end,
    },
    { "<leader>cv", desc = "chat", require("codecompanion").toggle },

    { "<leader>d", desc = "Diagnostics for current line", vim.diagnostic.open_float },
    { "<leader>D", desc = "Diagnostics for workspace", require("telescope.builtin").diagnostics },
    { "<leader>f", desc = "LSP format", vim.lsp.buf.format },
    {
      "<leader>F",
      desc = "Toggle autoformat",
      function()
        vim.g.autoformat = not vim.g.autoformat
        if vim.g.autoformat then
          print("Enabled format on write")
        else
          print("Disabled format on write")
        end
      end,
    },

    { "<leader>g", group = "git" },
    { "<leader>ga", desc = "Add", require("gitsigns").stage_hunk },
    { "<leader>gb", desc = "Blame", require("gitsigns").toggle_current_line_blame },
    { "<leader>gd", desc = "Diff", require("gitsigns").preview_hunk },
    {
      "<leader>go",
      desc = "Open selection in browser",
      function()
        require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser })
      end,
    },
    {
      "<leader>gO",
      desc = "Open file in browser",
      function()
        require("gitlinker").get_repo_url({ action_callback = require("gitlinker.actions").open_in_browser })
      end,
    },
    { "<leader>gu", desc = "Undo", require("gitsigns").reset_hunk },
    {
      "<leader>gy",
      desc = "Yank selection url",
      function()
        require("gitlinker").get_buf_range_url(
          "n",
          { action_callback = require("gitlinker.actions").copy_to_clipboard }
        )
      end,
    },
    {
      "<leader>gY",
      desc = "Yank repo url",
      function()
        require("gitlinker").get_repo_url({ action_callback = require("gitlinker.actions").copy_to_clipboard })
      end,
    },

    { "<leader>h", desc = "History", require("telescope.builtin").oldfiles },
    { "<leader>i", desc = "Toggle indent lines", vim.cmd.IBLToggle },
    { "<leader>k", desc = "LSP hover", vim.lsp.buf.hover },

    { "<leader>l", group = "LSP" },
    { "<leader>la", desc = "Code actions", vim.lsp.buf.code_action },
    { "<leader>ld", desc = "Definitions", require("telescope.builtin").lsp_definitions },
    { "<leader>lf", desc = "Format file", vim.lsp.buf.format },
    { "<leader>li", desc = "Implementations", require("telescope.builtin").lsp_implementations },
    { "<leader>ln", desc = "Rename", vim.lsp.buf.rename },
    { "<leader>lr", desc = "References", require("telescope.builtin").lsp_references },
    { "<leader>ls", desc = "Document symbols", require("telescope.builtin").lsp_document_symbols },
    { "<leader>lS", desc = "Workspace symbols", require("telescope.builtin").lsp_workspace_symbols },
    { "<leader>lt", desc = "Type definitions", require("telescope.builtin").lsp_type_definitions },
    { "<leader>n", desc = "LSP rename", vim.lsp.buf.rename },
    {
      "<leader>q",
      desc = "LSP hover",
      hidden = true,
      function()
        vim.lsp.buf.hover({ border = vim.g.border_style })
      end,
    }, -- TODO replaced by K
    { "<leader>t", group = "Telescope pickers", require("telescope.builtin").builtin },
    { "<leader>u", desc = "Git undo", require("gitsigns").reset_hunk },
    {
      "<leader>y",
      desc = "Yank file name",
      function()
        vim.fn.setreg("*", vim.fn.expand("%f"))
      end,
    },

    { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings

    -- `g`-based mappings are often already mapped, be careful adding new ones (use `:help gt`)
    { "gd", desc = "LSP definitions", require("telescope.builtin").lsp_definitions },

    {
      "K",
      desc = "LSP hover",
      function()
        vim.lsp.buf.hover({ border = vim.g.border_style })
      end,
    },

    { "oo", desc = "Add line below", "o<Esc>k" },
    { "OO", desc = "Add line above", "O<Esc>j" },
  },

  -- (v)isual mode
  v = {
    { "<leader>a", desc = "Code actions", vim.lsp.buf.code_action },

    { "<leader>c", group = "CodeCompanion" },
    { "<leader>ca", desc = "actions", require("codecompanion").actions },
    {
      "<leader>cc",
      desc = "prompt",
      function()
        vim.cmd("CodeCompanion")
      end,
    },
    {
      "<leader>cd",
      desc = "explain diagnostic",
      function()
        vim.cmd("CodeCompanion /lsp")
      end,
    },
    {
      "<leader>ce",
      desc = "explain",
      function()
        vim.cmd("CodeCompanion /explain")
      end,
    },
    {
      "<leader>cf",
      desc = "fix",
      function()
        vim.cmd("CodeCompanion /fix")
      end,
    },
    {
      "<leader>ct",
      desc = "write unit tests",
      function()
        vim.cmd("CodeCompanion /tests")
      end,
    },
    { "<leader>cv", desc = "chat", require("codecompanion").chat },

    { "<leader>f", desc = "Format selection", vim.lsp.buf.format },
    { "<leader>g", group = "git" },
    {
      "<leader>go",
      desc = "Open selection in browser",
      function()
        require("gitlinker").get_buf_range_url("v", { action_callback = require("gitlinker.actions").open_in_browser })
      end,
    },
    {
      "<leader>gy",
      desc = "Yank url to selection",
      function()
        require("gitlinker").get_buf_range_url(
          "v",
          { action_callback = require("gitlinker.actions").copy_to_clipboard }
        )
      end,
    },
    { "<leader>l", group = "LSP" },
    { "<leader>la", desc = "Code actions", vim.lsp.buf.code_action },
    { "<leader>lf", desc = "Format selection", vim.lsp.buf.format },

    -- swap these keymaps since I usually want the behavior of the first one
    { "p", desc = "Put and don't replace register", "P", noremap = true },
    { "P", desc = "Put and replace register", "p", noremap = true },

    -- These keymaps usually change the case of the selection, but it's easy to accidentally trigger
    -- them when trying to undo.
    { "u", desc = "", hidden = true, "<nop>" },
    { "U", desc = "", hidden = true, "<nop>" },
  },
}

for mode, modeMappings in pairs(wkMappings) do
  wk.add({
    { mode = { mode }, modeMappings },
  })
end
