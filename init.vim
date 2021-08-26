augroup InitAutoCmd
  autocmd!
augroup END

lua require('init')
runtime rc/colors.vim

set exrc   " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files
