if has('eval')
  autocmd InitAutoCmd BufEnter * call rubix#update_title()
endif

autocmd InitAutoCmd InsertEnter * setlocal nohlsearch
autocmd InitAutoCmd InsertLeave * setlocal hlsearch

" check timestamp more for 'autoread'
autocmd InitAutoCmd WinEnter * checktime

" disable paste
autocmd InitAutoCmd InsertLeave * if &paste | set nopaste mouse=a | echo 'nopaste' | endif

" update diff
autocmd InitAutoCmd InsertLeave * if &l:diff | diffupdate | endif

" go back to previous position of cursor if any
autocmd InitAutoCmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \  execute 'normal! g`"zvzz' |
  \ endif

if has('eval')
  command! -nargs=* Only call rubix#only()
  command! Kwbd call rubix#kwbd()
endif

if has('nvim')
  command! -nargs=0 Format :lua vim.lsp.buf.formatting()
endif
