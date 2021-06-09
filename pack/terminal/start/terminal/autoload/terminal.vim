function! s:get_last_mode(win) abort
  let l:buf = winbufnr(a:win)
  let l:last_mode = getbufvar(l:buf, 'last_mode', {})
  return get(l:last_mode, a:win, '')
endfunction

function! s:set_last_mode(win, mode) abort
  let l:buf = winbufnr(a:win)

  if getbufvar(l:buf, '&buftype') !=# 'terminal'
    return
  endif

  let l:last_mode = getbufvar(l:buf, 'last_mode', {})
  let l:last_mode[a:win] = a:mode
  call setbufvar(l:buf, 'last_mode', l:last_mode)
endfunction

function! terminal#save_mode() abort
  let l:win = winnr()
  if s:get_last_mode(l:win) ==# ''
    call s:set_last_mode(l:win, mode())
  endif

  return "\<c-\>\<c-n>"
endfunction

function! s:start_insert_term() abort
  if has('nvim')
    startinsert
  endif

  if has('terminal') && mode() !=# 't'
    execute 'normal i'
  endif
endfunction

let s:term = {
  \   'buf':           0,
  \   'last_vertical': 0,
  \   'last_height':   0,
  \   'last_width':    0,
  \   'last_topleft':  0,
  \ }

function! s:terminal_save() abort
  let l:win = winnr()

  let l:maxheight  = &lines - &cmdheight
  let l:maxheight -= &laststatus == 2  || &laststatus  == 1 &&     winnr('$') > 1 ? 1 : 0
  let l:maxheight -= &showtabline == 2 || &showtabline == 1 && tabpagenr('$') > 1 ? 1 : 0

  let s:term.last_topleft = winnr() == 1 ? 1 : 0
  let s:term.last_vertical = 0

  if winwidth(l:win) == &columns
    " term was horizontal
    let s:term.last_height = winheight(l:win)
  elseif winheight(l:win) == l:maxheight
    " term was vertical
    let s:term.last_vertical = 1
    let s:term.last_width = winwidth(l:win)
  else
    " unknown, reset
    let s:term.last_height = 0
    let s:term.last_width  = 0
  endif
endfunction

function! terminal#toggle(mods, bang) abort
  " user is in the terminal, return to the previous location
  if s:term.buf == bufnr('')
    let l:win = winnr()
    wincmd p

    if a:bang
      execute l:win.'close'
    endif

    return
  endif

  " if the terminal window is already shown...
  let l:win = bufwinnr(s:term.buf)
  if s:term.buf != 0 && l:win != -1
    " close the window if bang was used
    if a:bang
      execute l:win.'close'
      return
    endif

    " switch to it
    execute l:win.'wincmd w'
    return
  endif

  " don't create term if bang was used
  if a:bang
    return
  endif

  let l:mods = a:mods

  let l:vertical = match(l:mods, 'vertical') != -1
  if match(l:mods, 'topleft') == -1 && match(l:mods, 'botright') == -1
    let l:mods .= ' ' . (s:term.last_topleft ? 'topleft' : 'botright')
  endif

  let l:def_height = 10
  let l:def_width  = 80

  if s:term.last_height == 0 && s:term.last_width == 0
    " no previously opened term, use defaults
    let l:size = l:vertical ? l:def_width : l:def_height
  elseif l:vertical
    " term _must_ be vertical, if it was previously vertical, reuse that width,
    " otherwise default
    let l:size = s:term.last_width > 0 ? s:term.last_width : l:def_width
  elseif s:term.last_vertical
    " previous term was vertical, reuse its width
    let l:mods .= ' vertical'
    let l:size = s:term.last_width
  else
    " previous term was horizontal (or unknown), reuse its height
    let l:size = s:term.last_height > 0 ? s:term.last_height : l:def_height
  endif

  " create the window and switch to it
  execute l:mods.' '.l:size.'new'
  setlocal winfixwidth winfixheight

  " if the terminal buffer exists show it in the window
  if s:term.buf != 0 && bufexists(s:term.buf)
    let l:buf = bufnr('')
    execute 'buffer '.s:term.buf
    execute 'bdelete '.l:buf
    return
  endif

  " create a new terminal buffer
  if has('nvim')
    call termopen(&shell)
  endif

  if has('terminal')
    terminal ++curwin
  endif

  setlocal bufhidden=hide nobuflisted
  let s:term.buf = bufnr('')

  autocmd RubixTerm BufLeave <buffer> call s:terminal_save()

  call s:start_insert_term()
endfunction

function! terminal#setup() abort
  call s:start_insert_term()
  autocmd RubixTerm BufEnter <buffer> call terminal#restore_mode()
endfunction

function! s:remove_last_mode(win) abort
  let l:buf = winbufnr(a:win)

  if getbufvar(l:buf, '&buftype') !=# 'terminal'
    return ''
  endif

  let l:last_mode = getbufvar(l:buf, 'last_mode', {})

  if get(l:last_mode, a:win, '') ==# ''
    return ''
  endif

  let l:ret = remove(l:last_mode, a:win)
  call setbufvar(l:buf, 'last_mode', l:last_mode)
  return l:ret
endfunction

function! terminal#restore_mode() abort
  let l:win = winnr()
  let l:mode = s:remove_last_mode(l:win)

  if l:mode ==# 't'
    call s:start_insert_term()
  endif
endfunction

function! terminal#new() abort
  if has('nvim')
    enew
    call termopen(&shell)
    return
  endif

  if has('terminal')
    enew
    terminal ++curwin
  endif
endfunction
