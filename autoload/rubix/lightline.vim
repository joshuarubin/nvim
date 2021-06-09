scriptencoding utf-8

function! rubix#lightline#mode() abort
  if s:is_filetype_mode_filetype()
    return toupper(&filetype)
  endif

  return lightline#mode()
endfunction

function! rubix#lightline#crypt() abort
  if exists('+key') && !empty(&key)
    return ''
  endif

  return ''
endfunction

function! rubix#lightline#git() abort
  let l:status = FugitiveHead()
  return len(l:status) > 0 && winwidth(0) >= 70 ? ' ' . l:status : ''
endfunction

function! rubix#lightline#filename() abort
  return s:filename('%:.') . s:modified() . s:readonly()
endfunction

function! rubix#lightline#full_filename() abort
  return s:filename('%:p') . s:modified() . s:readonly()
endfunction

function! rubix#lightline#filetype() abort
  if winwidth(0) < 80
    return ''
  endif

  if s:is_no_filetype_filetype()
    return ''
  endif

  if &filetype !=# ''
    return &filetype . ' ' . WebDevIconsGetFileTypeSymbol() . ' '
  endif

  return ''
endfunction

function! rubix#lightline#spell() abort
  if &spell
    return &spelllang
  endif

  return ''
endfunction

function! rubix#lightline#paste() abort
  if &paste
    return 'PASTE'
  endif

  return ''
endfunction

function! rubix#lightline#status_line_info() abort
  if s:is_no_lineinfo_filetype()
    return ''
  endif

  let l:fname = expand('%:f')

  if l:fname =~# '^term:\/\/'
    return ''
  endif

  return printf('%s%.0f%% %d/%d☰ :%d',
    \   winwidth(0) < 120 ? ' ' : '',
    \   round((line('.') * 1.0) / line('$') * 100),
    \   line('.'),
    \   line('$'),
    \   col('.')
    \ )
endfunction

function! rubix#lightline#line_info() abort
  if s:is_no_lineinfo_filetype()
    return ''
  endif

  let l:fname = expand('%:f')

  if l:fname =~# '^term:\/\/'
    return ''
  endif

  return '%{rubix#lightline#status_line_info()}'
endfunction

function! s:is_filetype_mode_filetype() abort
  return index(g:lightline_filetype_mode_filetypes, &filetype) >= 0
endfunction

function! s:is_no_lineinfo_filetype() abort
  return index(g:lightline_no_lineinfo_filetypes, &filetype) >= 0
endfunction

function! s:is_no_filetype_filetype() abort
  return index(g:lightline_no_filetype_filetypes, &filetype) >= 0
endfunction

function! s:is_no_filename_filetype() abort
  return index(g:lightline_no_filename_filetypes, &filetype) >= 0
endfunction

function! s:is_readonly_filetype() abort
  return index(g:lightline_readonly_filetypes, &filetype) >= 0
endfunction

function! s:readonly() abort
  if s:is_readonly_filetype()
    return ''
  endif

  if &readonly
    return ' '
  endif

  return ''
endfunction

function! s:filename(fmt) abort
  if s:is_no_filename_filetype()
    return ''
  endif

  if &filetype ==# 'help'
    return expand('%:t')
  endif

  let l:fname = expand(a:fmt)

  if l:fname =~# '^term:\/\/'
    " return the 'short filename' (e.g. shell name)
    return s:filename('%:t')
  endif

  if l:fname !=# ''
    return l:fname
  endif

  return '[No Name]'
endfunction

function! s:modified() abort
  if s:is_readonly_filetype()
    return ''
  endif

  if &modified
    return '[+]'
  endif

  if &modifiable
    return ''
  endif

  return '[-]'
endfunction

function! rubix#lightline#errors() abort
  let l:errors = luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])")
  return l:errors > 0 ? ' ' . l:errors : ''
endfunction


function! rubix#lightline#warnings() abort
  let l:warnings = luaeval("vim.lsp.diagnostic.get_count(0, [[Warning]])")
  return l:warnings > 0 ? ' ' . l:warnings : ''
endfunction
