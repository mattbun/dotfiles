local map = function(mode, hotkey, cmd, opts)
  opts = opts or { noremap = true, silent = true }
  return vim.api.nvim_set_keymap(mode, hotkey, cmd, opts)
end

-- Leader-based shortcuts
map("n", "<leader>~", "<Cmd>Telescope find_files cwd=~ disable_devicons=true<CR>")
map("n", "<leader><leader>", "<Cmd>Telescope find_files disable_devicons=true<cr>")
map("n", "<leader>a", "<Cmd>Gitsigns stage_hunk<CR>")
map("n", "<leader>B", "<Cmd>Gitsigns toggle_current_line_blame<CR>")
map("n", "<leader>[", "<C-o>")
map("n", "<leader>]", "<C-i>")
map("n", "<leader>b", "<Cmd>Telescope buffers disable_devicons=true<CR>")
map("n", "<leader>d", "<Cmd>Gitsigns preview_hunk<CR>")
map("n", "<leader>fb", "<Cmd>Telescope buffers disable_devicons=true<CR>")
map("n", "<leader>ff", "<Cmd>Telescope find_files disable_devicons=true<CR>")
map("n", "<leader>fg", "<Cmd>Telescope live_grep disable_devicons=true<CR>")
map("n", "<leader>g", "<Cmd>Telescope grep_string disable_devicons=true<CR>")
map("n", "<leader>8", "<Cmd>Telescope grep_string disable_devicons=true<CR>")
map("n", "<leader>h", "<Cmd>Telescope oldfiles disable_devicons=true<CR>")
map("n", "<leader>p", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
map(
  "n",
  "<leader>P",
  "<Cmd>lua vim.g.autoformat = not vim.g.autoformat; if vim.g.autoformat then print 'autoformat enabled' else print 'autoformat disabled' end<CR>"
)
map("n", "<leader>t", "<Cmd>NvimTreeToggle<CR>")
map("n", "<leader>u", "<Cmd>Gitsigns reset_hunk<CR>")
map("n", "<leader>w", "<Cmd>Telescope lsp_document_diagnostics<CR>")
map("n", "<leader>W", "<Cmd>Telescope lsp_workspace_diagnostics<CR>")
map("n", "<leader>y", "<Cmd>let @*=expand('%f')<CR>")

-- Shortcuts that start with `g` are generally for lsp-related things
map("n", "ga", "<Cmd>Telescope lsp_code_actions<CR>")
map("v", "ga", "<Cmd>lua vim.lsp.buf.range_code_action()<CR>", {}) -- TODO switch to telescope
map(
  "n",
  "gb",
  '<Cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<CR>'
)
map(
  "v",
  "gb",
  '<Cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<CR>',
  {}
)
map(
  "n",
  "gB",
  '<Cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<CR>'
)
map("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")
map("n", "gh", "<Cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "gr", "<Cmd>Telescope lsp_references<CR>")
map("n", "gs", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
map("n", "gt", "<Cmd>lua vim.lsp.buf.type()<CR>")
map("n", "gw", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false,show_header=false})<CR>")
map(
  "n",
  "gy",
  '<Cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>'
)
map(
  "v",
  "gy",
  '<Cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>',
  {}
)
map(
  "n",
  "gY",
  '<Cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>'
)

-- Make arrows move, select, and cancel in wildmenu (like when tab completing a command like ':e')
map("c", "<up>", 'pumvisible() ? "<C-p>" : "<up>"', { noremap = true, expr = true })
map("c", "<down>", 'pumvisible() ? "<C-n>" : "<down>"', { noremap = true, expr = true })
map("c", "<left>", 'pumvisible() ? "<C-e>" : "<left>"', { noremap = true, expr = true })
map("c", "<right>", 'pumvisible() ? "<C-y>" : "<right>"', { noremap = true, expr = true })
