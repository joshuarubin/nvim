set nocompatible

augroup InitAutoCmd
  autocmd!
augroup END

runtime rc/settings.vim
runtime rc/plugins.vim

if has('nvim')
  lua require('init')
endif

runtime rc/mappings.vim
runtime rc/commands.vim
runtime rc/colors.vim

set exrc   " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files
