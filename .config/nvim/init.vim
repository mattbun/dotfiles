set title  "set the terminal title
set number  "show line numbers on the side
set mouse=a  "be able to use a mouse with vim. you won't be able to do a normal copy/paste though. Instead, use "+y to copy and "+p to paste
set ai  "auto indent
set si  "smart indent
set ic  "ignore case in searches
set hls  "highlight search matches. disable temporarily with :noh

"tabs are two spaces
set tabstop=2
set shiftwidth=2
set expandtab

"show bad indentation
set list
set listchars=tab:!-,trail:-

"show substitutions
set inccommand=nosplit

"show a guide line at 120 characters
set colorcolumn=120

"oo to insert a new line below where you are, OO to insert above
nmap oo o<Esc>k
nmap OO O<Esc>j

"Accidentally making everything lower case is no fun :(
vmap u <nop>
vmap U <nop>

syntax on  "syntax highlighting
filetype plugin indent on  "figure out file types and stuff

"use system clipboard by default
set clipboard=unnamedplus

"Set up python
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

"Uncomment this to ignore whitespace in vimdiff
"if &diff
"    " diff mode
"    set diffopt+=iwhite
"endif

"Compare what's in the buffer with what's saved to disk
function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

"Time for plugins
"setup Plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

"Plug 'https://github.com/benekastah/neomake.git'
Plug 'w0rp/ale'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/AndrewRadev/switch.vim.git'
Plug 'https://github.com/AndrewRadev/linediff.vim.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/moll/vim-node.git'
Plug 'pangloss/vim-javascript'
Plug 'https://github.com/flazz/vim-colorschemes.git'
Plug 'https://github.com/keith/swift.vim.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-repeat.git'
Plug 'airblade/vim-gitgutter'
Plug 'wesQ3/vim-windowswap'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'cloudhead/neovim-fuzzy'
Plug 'jremmen/vim-ripgrep'
Plug 'gcmt/taboo.vim'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'artur-shaik/vim-javacomplete2'
"Plug 'DonnieWest/VimStudio'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'

call plug#end()

let g:ale_linters = {
\   'javascript': ['eslint'],
\}

let g:ale_fixers = {
\   'javascript': ['eslint'],
\}

let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'

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
"autocmd! BufWritePost * Neomake
"let g:neomake_javascript_enabled_makers = ['eslint']  "use eslint on javascript files

"Nerdtree stuff
"Open nerdtree if I open a folder
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
"Change color of files based on their file type
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

"Use terminal true color
set termguicolors

"badwolf is nice
"let g:badwolf_tabline = 3
"colorscheme badwolf

"Liking papercolor lately
"disable background
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': {
  \       'transparent_background' : 1
  \     }
  \   }
  \ }
colorscheme PaperColor
set background=dark

"Custom tab name: [working directory name] [filename][file modified flag]
let g:taboo_tab_format = " [%P] %f%m "

"Turn on javacomplete
"autocmd FileType java setlocal omnifunc=javacomplete#Complete

"Deoplete stuff
let g:deoplete#enable_at_startup = 1  "enable deoplete
let g:deoplete#disable_auto_complete = 1  "disable autocomplete and just use tab when I want it
"If deoplete autocomplete is on you'll want this:
"function g:Multiple_cursors_before()
"    let g:deoplete#disable_auto_complete = 1
"endfunction
"function g:Multiple_cursors_after()
"    let g:deoplete#disable_auto_complete = 0
"endfunction

" deoplete tab-complete
"navigate entries using tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"or shift tab
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"close the window when I hit enter
inoremap <expr> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")
"show completions when I hit tab
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

"Change ultisnips expand trigger since it interferes with deoplete
let g:UltiSnipsExpandTrigger = "<leader>e"

"Terminal
tnoremap <Esc> <C-\><C-n>

"Lightline config
let g:lightline = {
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ }
      \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

"Now for some shortcuts
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>g :Commits<CR>
nnoremap <silent> <leader>r :Rg<CR>
nnoremap <silent> <leader>n :NERDTreeToggle<CR>
nnoremap <silent> <leader>s :Snippets<CR>
