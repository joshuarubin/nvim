let s:dir = '~/.vim'

if has('nvim')
  let s:dir = stdpath('config')
endif

function! rubix#config#dir(suffix) abort
  return expand(s:dir . '/' . a:suffix)
endfunction
