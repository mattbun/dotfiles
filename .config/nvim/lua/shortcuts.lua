local map = function(mode, hotkey, cmd, opts)
  opts = opts or { noremap = true, silent = true }
  return vim.api.nvim_set_keymap(mode, hotkey, cmd, opts)
end

-- Leader-based shortcuts
map("n", "<leader><leader>", "<Cmd>Telescope find_files disable_devicons=true<cr>")
map("n", "<leader>B", "<Cmd>Gitsigns toggle_current_line_blame<CR>")
map("n", "<leader>[", "<Cmd>bp<CR>") -- TODO
map("n", "<leader>]", "<Cmd>bn<CR>") -- TODO
map("n", "<leader>b", "<Cmd>Telescope buffers disable_devicons=true<CR>")
map("n", "<leader>d", "<Cmd>Gitsigns preview_hunk<CR>")
map("n", "<leader>fb", "<Cmd>Telescope buffers disable_devicons=true<CR>")
map("n", "<leader>ff", "<Cmd>Telescope find_files disable_devicons=true<CR>")
map("n", "<leader>fg", "<Cmd>Telescope live_grep disable_devicons=true<CR>")
map("n", "<leader>g", "<Cmd>Telescope grep_string disable_devicons=true<CR>")
map("n", "<leader>8", "<Cmd>Telescope grep_string disable_devicons=true<CR>")
map("n", "<leader>p", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
map(
  "n",
  "<leader>P",
  "<Cmd>lua vim.g.autoformat = not vim.g.autoformat; if vim.g.autoformat then print 'autoformat enabled' else print 'autoformat disabled' end<CR>"
)
map("n", "<leader>t", "<Cmd>NvimTreeToggle<CR>")
map("n", "<leader>u", "<Cmd>Gitsigns reset_hunk<CR>")

-- Shortcuts that start with `g` are generally for lsp-related things
map("n", "ga", "<Cmd>Telescope lsp_code_actions<CR>")
map("v", "ga", "<Cmd>Telescope lsp_range_code_actions<CR>") -- TODO this doesn't work
map("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")
map("n", "gh", "<Cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "gr", "<Cmd>Telescope lsp_references<CR>")
map("n", "gs", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
map("n", "gt", "<Cmd>lua vim.lsp.buf.type()<CR>")

-- Make arrows move, select, and cancel in wildmenu (like when tab completing a command like ':e')
map("c", "<up>", 'pumvisible() ? "<C-p>" : "<up>"', { noremap = true, expr = true })
map("c", "<down>", 'pumvisible() ? "<C-n>" : "<down>"', { noremap = true, expr = true })
map("c", "<left>", 'pumvisible() ? "<C-e>" : "<left>"', { noremap = true, expr = true })
map("c", "<right>", 'pumvisible() ? "<C-y>" : "<right>"', { noremap = true, expr = true })
