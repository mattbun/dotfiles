local map = function(mode, hotkey, cmd, opts)
  opts = opts or { noremap = true, silent = true }
  return vim.api.nvim_set_keymap(mode, hotkey, cmd, opts)
end

-- Leader-based shortcuts
map("n", "<leader><leader>", "<Cmd>Telescope find_files disable_devicons=true<cr>")
map("n", "<leader>[", "<C-o>")
map("n", "<leader>]", "<C-i>")
map("n", "<leader>#", "<Cmd>Telescope grep_string disable_devicons=true<CR>")
map("n", "<leader>*", "<Cmd>Telescope grep_string disable_devicons=true<CR>")
map("n", "<leader>~", "<Cmd>Telescope find_files cwd=~ disable_devicons=true<CR>")
map("n", "<leader>b", "<Cmd>Telescope buffers disable_devicons=true<CR>")
map("n", "<leader>d", "<Cmd>Gitsigns preview_hunk<CR>")
-- (f)ind
map("n", "<leader>fa", "<Cmd>Telescope lsp_code_actions<CR>")
map("v", "<leader>fa", "<Cmd>lua vim.lsp.buf.range_code_action()<CR>", {}) -- TODO switch to telescope
map("n", "<leader>fb", "<Cmd>Telescope buffers disable_devicons=true<CR>")
map("n", "<leader>fd", "<Cmd>Telescope lsp_definitions<CR>")
map("n", "<leader>ff", "<Cmd>Telescope find_files disable_devicons=true<CR>")
map("n", "<leader>fg", "<Cmd>Telescope live_grep disable_devicons=true<CR>")
map("n", "<leader>fh", "<Cmd>Telescope oldfiles disable_devicons=true<CR>")
map("n", "<leader>fi", "<Cmd>Telescope lsp_implementations<CR>")
map("n", "<leader>fr", "<Cmd>Telescope lsp_references<CR>")
map("n", "<leader>ft", "<Cmd>Telescope lsp_type_definitions<CR>")
map("n", "<leader>fT", "<Cmd>Telescope<CR>")
-- (g)it
map("n", "<leader>ga", "<Cmd>Gitsigns stage_hunk<CR>")
map("n", "<leader>gb", "<Cmd>Gitsigns toggle_current_line_blame<CR>")
map("n", "<leader>gd", "<Cmd>Gitsigns preview_hunk<CR>")
map(
  "n",
  "go",
  '<Cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<CR>'
)
map(
  "v",
  "go",
  '<Cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<CR>',
  {}
)
map(
  "n",
  "gO",
  '<Cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<CR>'
)
map("n", "<leader>gu", "<Cmd>Gitsigns reset_hunk<CR>")
map(
  "n",
  "<leader>gy",
  '<Cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>'
)
map(
  "v",
  "<leader>gy",
  '<Cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>',
  {}
)
map(
  "n",
  "<leader>gY",
  '<Cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".copy_to_clipboard})<CR>'
)
map("n", "<leader>h", "<Cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "<leader>n", "<Cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>p", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
map(
  "n",
  "<leader>P",
  "<Cmd>lua vim.g.autoformat = not vim.g.autoformat; if vim.g.autoformat then print 'autoformat enabled' else print 'autoformat disabled' end<CR>"
)
map("n", "<leader>s", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
map("n", "<leader>t", "<Cmd>NvimTreeToggle<CR>")
map("n", "<leader>u", "<Cmd>Gitsigns reset_hunk<CR>")
map("n", "<leader>w", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false,show_header=false})<CR>")
map("n", "<leader>W", "<Cmd>Telescope lsp_workspace_diagnostics<CR>")
map("n", "<leader>y", "<Cmd>let @*=expand('%f')<CR>")

-- `g`-based mappings are often already mapped, be careful adding new ones (use `:help gt`)
map("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")

-- Make arrows move, select, and cancel in wildmenu (like when tab completing a command like ':e')
map("c", "<up>", 'pumvisible() ? "<C-p>" : "<up>"', { noremap = true, expr = true })
map("c", "<down>", 'pumvisible() ? "<C-n>" : "<down>"', { noremap = true, expr = true })
map("c", "<left>", 'pumvisible() ? "<C-e>" : "<left>"', { noremap = true, expr = true })
map("c", "<right>", 'pumvisible() ? "<C-y>" : "<right>"', { noremap = true, expr = true })
