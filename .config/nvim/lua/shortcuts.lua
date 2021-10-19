local map = function(mode, hotkey, cmd)
	return vim.api.nvim_set_keymap(mode, hotkey, cmd, { noremap = true, silent = true })
end

map("n", "<leader><leader>", "<Cmd>Telescope find_files disable_devicons=true<cr>")
map("n", "<leader>B", "<Cmd>Gitsigns toggle_current_line_blame<CR>")
map("n", "<leader>[", "<Cmd>bp<CR>") -- TODO
map("n", "<leader>]", "<Cmd>bn<CR>") -- TODO
map("n", "<leader>b", "<Cmd>Telescope buffers disable_devicons=true<CR>")
map("n", "<leader>d", "<Cmd>Gitsigns preview_hunk<CR>")
map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>")
map("n", "<leader>ff", "<Cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>")
map("n", "<leader>n", "<Cmd>NvimTreeToggle<CR>")
map("n", "<leader>p", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
map("n", "<leader>u", "<Cmd>Gitsigns reset_hunk<CR>")

map("n", "ga", "<Cmd>Lspsaga code_action<CR>")
map("v", "ga", "<Cmd><C-U>Lspsaga range_code_action<CR>")
map("n", "gd", "<Cmd>Lspsaga lsp_finder<CR>")
map("n", "gh", "<Cmd>Lspsaga hover_doc<CR>")
map("n", "gH", "<Cmd>Lspsaga preview_definition<CR>")
map("n", "gr", "<Cmd>Lspsaga rename<CR>")
map("n", "gs", "<Cmd>Lspsaga signature_help<CR>")

map("n", "<C-f>", "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
map("n", "<C-b>", "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")
