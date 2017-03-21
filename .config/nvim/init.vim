set title
set number "show line numbers on the side
set ai
set si
set ic  "ignore case for searched
syntax on
set background=dark
set hls  "highlight search matches. disable temporarily with :noh
set mouse=a  "be able to use a mouse with vim. you won't be able to do a normal copy/paste though. Instead, use "+y to copy and "+p to paste

"execute pathogen#infect()
filetype plugin indent on

set nocompatible
filetype plugin on

"Uncomment this to ignore whitespace in vimdiff
"if &diff
"    " diff mode
"    set diffopt+=iwhite
"endif

nmap oo o<Esc>k
nmap OO O<Esc>j

function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

"Accidentally making everything lower case is no fun :(
vmap u <nop>
vmap U <nop>

let g:switch_mapping = "-"
let g:switch_custom_definitions =
      \ [
      \   ['!=', '=='],
      \   ['0', '1'],
      \   ['ON', 'OFF'],
      \   ['''', '"']
      \ ]

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'https://github.com/benekastah/neomake.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/AndrewRadev/switch.vim.git'
Plug 'https://github.com/rking/ag.vim.git'
Plug 'https://github.com/AndrewRadev/linediff.vim.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/moll/vim-node.git'
Plug 'https://github.com/flazz/vim-colorschemes.git'
Plug 'https://github.com/keith/swift.vim.git'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

call plug#end()

autocmd! BufWritePost * Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
"let g:neomake_open_list = 2

colorscheme badwolf
set tabstop=4
set shiftwidth=4
set expandtab

"show bad indentation
set list
set listchars=tab:!-,trail:-

let g:badwolf_tabline = 3
colorscheme badwolf

"show substitutions
set inccommand=nosplit

"show a guide line at 100 characters
set colorcolumn=100

au VimEnter * if !&diff | tab all | tabfirst | endif
