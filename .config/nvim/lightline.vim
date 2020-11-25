Plug 'itchyny/lightline.vim'
Plug 'mike-hearn/base16-vim-lightline'

"Try to use the shell theme for lightline (lightline themes use underscores ugh)
let $lightline_colorscheme = substitute(g:colors_name, "-", "_", "g")

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
\    },
\    'colorscheme': $lightline_colorscheme
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
