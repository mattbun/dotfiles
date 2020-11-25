Plug 'https://github.com/AndrewRadev/switch.vim.git'

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
