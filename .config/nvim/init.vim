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
lua require('shortcuts')

highlight SignColumn guibg=#00000000
highlight LineNr guibg=#00000000

" Format on save by default but provide a variable to toggle it on and off
lua vim.g.autoformat = true
augroup AutoFormat
  autocmd!
  autocmd BufWritePre * lua if vim.g.autoformat then vim.lsp.buf.formatting_sync() end
augroup END

