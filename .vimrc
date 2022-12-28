set title   "set the terminal title
set number  "show line numbers on the side
set mouse=a "enable mouse in all modes
set ai      "auto indent
set si      "smart indent
set ic      "ignore case in searches
set hls     "highlight search matches. disable temporarily with :noh
set hidden  "Allow unsaved changes to be hidden in buffers

"leader is space
let mapleader=" "

"terminal title is the filepath relative to working directory and then modified flags
set titlestring=%f%m

"tabs are two spaces (this can get overridden by editorconfig)
set tabstop=2
set shiftwidth=2
set expandtab

"show a guide line at 100 characters
set colorcolumn=100

"don't add a newline at the end if it's missing
set nofixendofline

"Use terminal true color
set termguicolors

"oo to insert a new line below where you are, OO to insert above
nmap oo o<Esc>k
nmap OO O<Esc>j

"Accidentally making everything lower case is no fun :(
vmap u <nop>
vmap U <nop>

" syntax hightlighting
syntax on

" figure out file types automatically
" https://vi.stackexchange.com/a/10125
filetype plugin indent on

"use system clipboard by default
set clipboard=unnamedplus

"Compare what's in the buffer with what's saved to disk
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

