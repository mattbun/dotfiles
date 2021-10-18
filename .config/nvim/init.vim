source ~/.vimrc

"show substitutions (neovim-only)
set inccommand=nosplit

" Make up and down work in wildmenu (like when tab completing a command like ':Coc')
cnoremap <expr> <up>   pumvisible() ? "<C-p>" : "<up>"
cnoremap <expr> <down> pumvisible() ? "<C-n>" : "<down>"

"Set up python
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

lua require('plugins')

highlight SignColumn guibg=#00000000
highlight LineNr guibg=#00000000

autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_sync()
autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync()
autocmd BufWritePre *.yml lua vim.lsp.buf.formatting_sync()
autocmd BufWritePre *.json lua vim.lsp.buf.formatting_sync()
autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync()
