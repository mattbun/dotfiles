set title  "set the terminal title
set titlestring=%f%m  "terminal title is the filepath relative to working directory and then modified flags
set number  "show line numbers on the side
set mouse=a  "be able to use a mouse with vim. you won't be able to do a normal copy/paste though. Instead, use "+y to copy and "+p to paste
set ai  "auto indent
set si  "smart indent
set ic  "ignore case in searches
set hls  "highlight search matches. disable temporarily with :noh
set hidden "Allow unsaved changes to be hidden in buffers

"tabs are four spaces
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

"Time for plugins
"setup Plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

"Plug 'https://github.com/benekastah/neomake.git'
"Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'  "github integration for fugitive
Plug 'https://github.com/AndrewRadev/switch.vim.git'
Plug 'https://github.com/AndrewRadev/linediff.vim.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/moll/vim-node.git'
Plug 'pangloss/vim-javascript'
Plug 'NLKNguyen/papercolor-theme'
Plug 'https://github.com/keith/swift.vim.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-repeat.git'
Plug 'wesQ3/vim-windowswap'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'gcmt/taboo.vim' "tab renaming and stuff
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
Plug 'jparise/vim-graphql'

"coc is cool
"Plug 'HerringtonDarkholme/yats.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
\    'coc-json',
\    'coc-tslint-plugin',
\    'coc-tsserver',
\    'coc-yaml',
\    'coc-highlight',
\    'coc-git',
\    'coc-calc',
\]

call plug#end()

"let g:ale_linters = {
"\   'javascript': ['eslint'],
"\   'typescript': ['tslint'],
"\}
"
"let g:ale_fixers = {
"\   'javascript': ['eslint'],
"\}
"
"let g:ale_sign_error = '✖'
"let g:ale_sign_warning = '⚠'

"setup switch.vim and some custom definitions
let g:switch_mapping = "-"
let g:switch_custom_definitions =
      \ [
      \   ['!=', '=='],
      \   ['0', '1'],
      \   ['ON', 'OFF'],
      \   ['''', '"']
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
highlight SignColumn guibg=#00000000

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

"Lightline config
let g:lightline = {
\    'component_function': {
\        'filename': 'LightlineFilename',
\        'gitstatus': 'LightlineGitStatus',
\    },
\    'active': {
\        'right': [
\            [ 'lineinfo', 'percent' ],
\            [ 'filetype' ],
\            [ 'gitstatus' ],
\        ]
\    }
\}

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

"function! LightlineFilename()
"  return expand('%f')
"endfunction

function! LightlineGitStatus() abort
  let status = get(g:, 'coc_git_status', '')
  return winwidth(0) > 120 ? status : ''
endfunction

"Now for some shortcuts
nnoremap <silent> <leader><leader> :Files<CR>
nnoremap <silent> <leader>g :Commits<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <silent> <leader>n :NERDTreeToggle<CR>:NERDTreeRefreshRoot<CR>
"nnoremap <silent> <leader>x :ALEFix<CR>
"Reload vim config
nnoremap <silent> <leader>v :so $MYVIMRC<CR>
nnoremap <leader>V :tabe $MYVIMRC<CR>
nnoremap <leader>o :Gbrowse<CR>
nnoremap <leader>m :silent !open "%"<CR>
nnoremap <leader>d :Gdiff<CR>
nnoremap <leader>g :G<CR>
"nnoremap <leader>T :Filetypes<CR>
nnoremap <leader>t :vsplit %<.test.js<CR>
nnoremap <leader>T :e %<.test.js

nnoremap <leader>b :Buffers<CR>
nnoremap <leader>\| :Buffers<CR>
nnoremap <leader>] :b#<CR>

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

"coc
" Better display for messages
"set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
"set signcolumn=auto

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> ? :call <SID>show_documentation()<CR>
nnoremap <silent> <TAB> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight') | silent call CocAction('doHover')
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
