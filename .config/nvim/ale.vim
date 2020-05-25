Plug 'w0rp/ale'

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\   'shell': ['bash -n'],
\}

let g:ale_fixers = {
\   'javascript': ['eslint'],
\}

let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'


nnoremap <silent> <leader>x :ALEFix<CR>
