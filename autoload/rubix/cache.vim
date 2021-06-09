let s:dir = '~/.cache/vim'

if has('nvim')
  let s:dir = stdpath('cache')
endif

function! rubix#cache#dir(suffix) abort
  let l:dir = expand(s:dir . '/' . a:suffix)

  if !isdirectory(expand(l:dir))
    call mkdir(expand(l:dir), 'p')
  endif

  return l:dir
endfunction
