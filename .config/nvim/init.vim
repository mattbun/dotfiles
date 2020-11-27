source ~/.vimrc

"show substitutions (neovim-only)
set inccommand=nosplit

" Make up and down work in wildmenu (like when tab completing a command like ':Coc')
cnoremap <expr> <up>   pumvisible() ? "<C-p>" : "<up>"
cnoremap <expr> <down> pumvisible() ? "<C-n>" : "<down>"

"Set up python
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

"Time for plugins
"setup Plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'AndrewRadev/linediff.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'gcmt/taboo.vim' "tab renaming and stuff
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'  "github integration for fugitive
Plug 'tpope/vim-surround'
Plug 'wesQ3/vim-windowswap'
source ~/.config/nvim/lightline.vim
source ~/.config/nvim/switch.vim

"coc is cool, but not if node isn't installed
if executable('node')
  source ~/.config/nvim/coc.vim
else
  source ~/.config/nvim/ale.vim
endif

call plug#end()

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

