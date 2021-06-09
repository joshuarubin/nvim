scriptencoding utf-8

set background=dark

if has#colorscheme('iceberg')
  colorscheme iceberg
endif

augroup HighlightTODO
  " ensure any instance TODO or FIXME is highlighted as an Error in any filetype
  autocmd!
  autocmd WinEnter,VimEnter * :silent! call matchadd('Error', 'TODO', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('Error', 'FIXME', -1)
augroup END

highlight Comment gui=italic cterm=italic

sign define LspDiagnosticsSignError       text= texthl=LspDiagnosticsSignError       linehl= numhl=
sign define LspDiagnosticsSignWarning     text= texthl=LspDiagnosticsSignWarning     linehl= numhl=
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint        text= texthl=LspDiagnosticsSignHint        linehl= numhl=
