source ~/.vimrc

"show substitutions (neovim-only)
set inccommand=nosplit

lua require('lsp')
lua require('plugins')
lua require('shortcuts')

highlight SignColumn guibg=#00000000
highlight LineNr guibg=#00000000
