set title  "set the terminal title
set titlestring=%f%m  "terminal title is the filepath relative to working directory and then modified flags
set number  "show line numbers on the side
set mouse=a  "be able to use a mouse with vim. you won't be able to do a normal copy/paste though. Instead, use "+y to copy and "+p to paste
set ai  "auto indent
set si  "smart indent
set ic  "ignore case in searches
set hls  "highlight search matches. disable temporarily with :noh
set hidden "Allow unsaved changes to be hidden in buffers

"tabs are two spaces
set tabstop=2
set shiftwidth=2
set expandtab

"show bad indentation
set list
set listchars=tab:!-,trail:-

"show substitutions
set inccommand=nosplit

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

" Use theme from base16-universal-generator
source ~/.colors/vim.vim

"Time for plugins
"setup Plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

"Plug 'https://github.com/benekastah/neomake.git'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'  "github integration for fugitive
Plug 'https://github.com/AndrewRadev/switch.vim.git'
Plug 'https://github.com/AndrewRadev/linediff.vim.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/moll/vim-node.git'
Plug 'pangloss/vim-javascript'
Plug 'NLKNguyen/papercolor-theme'
Plug 'chriskempson/base16-vim'
Plug 'https://github.com/keith/swift.vim.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-repeat.git'
Plug 'wesQ3/vim-windowswap'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'gcmt/taboo.vim' "tab renaming and stuff
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sheerun/vim-polyglot'
Plug 'jparise/vim-graphql'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-eunuch'
source ~/.config/nvim/lightline.vim

"coc is cool, but not if node isn't installed
if executable('node')
  source ~/.config/nvim/coc.vim
else
  source ~/.config/nvim/ale.vim
endif

call plug#end()


"setup switch.vim and some custom definitions
let g:switch_mapping = "-"
let g:switch_custom_definitions =
      \ [
      \   ['!=', '=='],
      \   ['0', '1'],
      \   ['ON', 'OFF'],
      \   ['''', '"'],
      \   ['GET', 'POST', 'PUT', 'DELETE', 'PATCH']
      \ ]

"Nerdtree stuff
"Open nerdtree if I open a folder
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
"Change color of files based on their file type
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

"Make gutter and signs column have no background
highlight SignColumn guibg=#00000000
highlight LineNr guibg=#00000000
highlight GitGutterAdd guibg=#00000000
highlight CocGitAddedSign guibg=#00000000
highlight CocGitChangedSign guibg=#00000000
highlight CocGitRemovedSign guibg=#00000000
highlight CocGitTopRemovedSign guibg=#00000000
highlight CocGitChangeRemovedSign guibg=#00000000

"Custom tab name: [working directory name] [filename][file modified flag]
"let g:taboo_tab_format = " [%P] %f%m "
let g:taboo_tab_format = " %f%m "
let g:taboo_tabline = 1

if has("nvim")
  "Make escape work right in terminal? TODO is that right?
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>

  "close fzf with escape
  au FileType fzf tunmap <buffer> <Esc>
endif

"Show a preview window next to Rg results
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

"airline
"let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
"let g:airline#extensions#tabline#tab_min_count = 1 " minimum of 2 tabs needed to display the tabline

"Now for some shortcuts
nnoremap <silent> <leader><leader> :Files<CR>
nnoremap <silent> <leader>g :Commits<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <silent> <leader>n :NERDTreeToggle<CR>:NERDTreeRefreshRoot<CR>
"Reload vim config
nnoremap <silent> <leader>v :so $MYVIMRC<CR>
nnoremap <leader>V :tabe $MYVIMRC<CR>
nnoremap <leader>m :silent !open "%"<CR>
nnoremap <leader>D :Gdiff<CR>
nnoremap <leader>g :G<CR>
"nnoremap <leader>T :Filetypes<CR>
nnoremap <leader>t :vsplit %<.test.js<CR>
nnoremap <leader>T :e %<.test.js

nnoremap <leader>b :Buffers<CR>
nnoremap <leader>\| :Buffers<CR>
nnoremap <leader>[ :bp<CR>
nnoremap <leader>] :bn<CR>

"TODO which one of these makes more sense?
nnoremap <leader>= :b#<CR>
nnoremap <leader>p :b#<CR>

nnoremap <leader>N :TabooRename 

nnoremap <leader>q :q<CR>
nnoremap <leader>p :pwd<CR>

let s:term_buf = 0
let s:term_win = 0

function! TermToggle()
    if win_gotoid(s:term_win)
        hide
    else
        :terminal
        try
            exec "buffer " . s:term_buf
            exec "bd terminal"
        catch
            call termopen($SHELL, {"detach": 0})
            let s:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
            set nocursorline
        endtry
        startinsert!
        let s:term_win = win_getid()
    endif
endfunction

function! NewTermTab()
  tabnew
  terminal
  set nonumber
  set norelativenumber
  set signcolumn=no
  set nocursorline
  startinsert!
endfunction

nnoremap <leader>s :call NewTermTab()<CR>

