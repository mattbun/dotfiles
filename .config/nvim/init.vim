set title  "set the terminal title
set number  "show line numbers on the side
set mouse=a  "be able to use a mouse with vim. you won't be able to do a normal copy/paste though. Instead, use "+y to copy and "+p to paste
set ai  "auto indent
set si  "smart indent
set ic  "ignore case in searches
set hls  "highlight search matches. disable temporarily with :noh

syntax on  "syntax highlighting
filetype plugin indent on  "figure out file types and stuff

"Uncomment this to ignore whitespace in vimdiff
"if &diff
"    " diff mode
"    set diffopt+=iwhite
"endif

"oo to insert a new line below where you are, OO to insert above
nmap oo o<Esc>k
nmap OO O<Esc>j

"Compare what's in the buffer with what's saved to disk
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


"setup Plug
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
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-repeat.git'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

call plug#end()

"setup switch.vim and some custom definitions
let g:switch_mapping = "-"
let g:switch_custom_definitions =
      \ [
      \   ['!=', '=='],
      \   ['0', '1'],
      \   ['ON', 'OFF'],
      \   ['''', '"']
      \ ]

"setup neomake
autocmd! BufWritePost * Neomake
let g:neomake_javascript_enabled_makers = ['eslint']  "use eslint on javascript files
"let g:neomake_open_list = 2  "show a window below with results

"tabs are two spaces now
set tabstop=4
set shiftwidth=4
set expandtab

"show bad indentation
set list
set listchars=tab:!-,trail:-

"show substitutions
set inccommand=nosplit

"show a guide line at 100 characters
set colorcolumn=100

"open all files passed in command line as tabs
au VimEnter * if !&diff | tab all | tabfirst | endif

"Use terminal true color
set termguicolors

"I like badwolf for some reason
let g:badwolf_tabline = 3
colorscheme badwolf

"use system clipboard by default
set clipboard=unnamedplus
