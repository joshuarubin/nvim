function! rubix#update_title() abort
  if exists('b:term_title')
    let &titlestring='term://'.b:term_title
    return
  endif

  set titlestring=
endfunction

function! rubix#only() abort
  " figure out which buffers are visible in any tab
  let l:visible = {}
  for l:t in range(1, tabpagenr('$'))
    for l:b in tabpagebuflist(l:t)
      let l:visible[l:b] = 1
    endfor
  endfor

  " close any buffer that are loaded and not visible
  let l:tally = 0
  for l:b in range(1, bufnr('$'))
    if bufexists(l:b) && !has_key(l:visible, l:b) && !getbufvar(l:b, '&mod')
      let l:tally += 1
      exe 'bw ' . l:b
    endif
  endfor
  echon 'Deleted ' . l:tally . ' buffers'
endfun

function! rubix#maximize_toggle() abort
  let l:curpos = getcurpos()
  if tabpagenr() == 1
    tabedit %
  else
    tabclose
  endif
  call setpos('.', l:curpos)
endfunction

"http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window
"
"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function! rubix#kwbd() abort
  if !buflisted(winbufnr(0))
    execute ':confirm :bdelete'
    return
  endif

  let l:bufnum = winbufnr(0)
  let l:winnum = winnr()
  let l:i = 1

  while l:i <= winnr('$')
    if winbufnr(l:i) == l:bufnum
      execute l:i . 'wincmd w'
      let l:prev = bufnr('#')
      if l:prev > 0 && buflisted(l:prev) && l:prev != l:bufnum
        buffer #
      else
        bnext
      endif
    endif
    let l:i = l:i + 1
  endwhile

  execute l:winnum . 'wincmd w'

  let l:bufmax = bufnr('$')

  if buflisted(l:bufnum) || l:bufnum == winbufnr(0)
    execute ':confirm :bdelete ' . l:bufnum
  endif

  if bufnr('%') > l:bufmax
    set buflisted
    set bufhidden=delete
    set buftype=
    setlocal noswapfile
  endif
endfunction

function! rubix#preserve(command) abort
  " preparation: save last search, and cursor position.
  let l:_s=@/
  let l:l = line('.')
  let l:c = col('.')
  " do the business:
  execute a:command
  " clean up: restore previous search history, and cursor position
  let @/=l:_s
  call cursor(l:l, l:c)
endfunction

function! rubix#trim() abort
  call rubix#preserve("%s/\\s\\+$//e")
endfunction
