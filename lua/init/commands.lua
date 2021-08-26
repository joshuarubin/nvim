vim.cmd [[
  augroup InitAutoCmd
    autocmd!
  augroup END
]]

vim.cmd [[autocmd InitAutoCmd BufEnter * let &titlestring = exists('b:term_title') ? b:term_title : '']]

-- disable search highlighting in insert mode
vim.cmd [[autocmd InitAutoCmd InsertEnter * setlocal nohlsearch]]
vim.cmd [[autocmd InitAutoCmd InsertLeave * setlocal hlsearch]]

vim.cmd [[autocmd InitAutoCmd WinEnter * checktime]] -- check timestamp more for 'autoread'
vim.cmd [[autocmd InitAutoCmd InsertLeave * if &paste | set nopaste | echo 'nopaste' | endif]] -- disable paste
vim.cmd [[autocmd InitAutoCmd InsertLeave * if &l:diff | diffupdate | endif]] -- update diff

-- go back to previous position of cursor if any
vim.cmd [[autocmd InitAutoCmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |  execute 'normal! g`"zvzz' | endif]]

vim.cmd [[command! -nargs=0 Format :lua vim.lsp.buf.formatting()]]
