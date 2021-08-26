set nocompatible

augroup InitAutoCmd
  autocmd!
augroup END

runtime rc/settings.vim
lua require('init')
runtime rc/mappings.vim
runtime rc/commands.vim
runtime rc/colors.vim

set exrc   " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files
