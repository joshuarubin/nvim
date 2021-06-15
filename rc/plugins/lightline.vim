scriptencoding utf-8

" a light and configurable statusline/tabline
Plug 'itchyny/lightline.vim'

" provides bufferline functionality for lightline
Plug 'mengelbrecht/lightline-bufferline'

let g:lightline#bufferline#show_number=1
let g:lightline#bufferline#enable_devicons=1
let g:lightline#bufferline#unicode_symbols=1
let g:lightline#bufferline#filename_modifier=':t'
let g:lightline#bufferline#unnamed = '[No Name]'

let g:lightline_readonly_filetypes = ['help', 'man', 'qf', 'taskreport', 'taskinfo']
let g:lightline_filetype_mode_filetypes = ['help', 'man', 'qf', 'defx']
let g:lightline_no_lineinfo_filetypes = ['taskreport', 'taskinfo', 'defx']
let g:lightline_no_filetype_filetypes = ['man', 'help', 'qf', 'taskreport', 'taskinfo', 'defx']
let g:lightline_no_filename_filetypes = ['qf', 'taskreport', 'taskinfo', 'defx']

let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ 'separator': { 'left': "", 'right': "" },
      \ 'subseparator': { 'left': "", 'right': "" },
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'crypt', 'paste', 'spell' ],
      \     [ 'filename' ],
      \   ],
      \   'right': [
      \     [ 'filetype', 'lineinfo' ],
      \     [ 'warnings', 'errors', 'git' ],
      \   ],
      \ },
      \ 'inactive': {
      \   'left': [
      \     [ ],
      \     [ ],
      \     [ 'fullfilename' ]
      \   ],
      \   'right': [
      \     [ 'filetype' ],
      \   ]
      \ },
      \ 'tabline': {
      \   'left': [
      \     [ 'buffers' ]
      \   ],
      \   'right': [
      \     [ 'lambda' ]
      \   ]
      \ },
      \ 'component': {
      \   'lambda': 'λ',
      \ },
      \ 'component_function': {
      \   'git':          'rubix#lightline#git',
      \   'filename':     'rubix#lightline#filename',
      \   'fullfilename': 'rubix#lightline#full_filename',
      \   'filetype':     'rubix#lightline#filetype',
      \   'mode':         'rubix#lightline#mode',
      \   'crypt':        'rubix#lightline#crypt',
      \   'spell':        'rubix#lightline#spell',
      \   'paste':        'rubix#lightline#paste',
      \ },
      \ 'component_expand': {
      \   'lineinfo':     'rubix#lightline#line_info',
      \   'errors':       'rubix#lightline#errors',
      \   'warnings':     'rubix#lightline#warnings',
      \   'buffers':      'lightline#bufferline#buffers',
      \ },
      \ 'component_type': {
      \   'errors':   'error',
      \   'warnings': 'warning',
      \   'buffers':  'tabsel',
      \ },
      \ 'enable': { 'statusline': 1, 'tabline': 1 },
      \ }

augroup InitLightline
 autocmd!
 autocmd User LspDiagnosticsChanged call lightline#update()
augroup END
