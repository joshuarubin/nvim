command! -bang -nargs=0 TerminalToggle :call terminal#toggle(<q-mods>, <bang>0)

augroup RubixTerm
  autocmd!
  autocmd TermOpen * :call terminal#setup()

  if has('nvim')
    autocmd TermOpen * setlocal nolist nonumber norelativenumber sidescrolloff=0 scrolloff=0 winfixheight signcolumn=no

    " switch to insert mode and press <up> for shell history when in normal mode
    autocmd TermOpen * nnoremap <buffer> <up> i<up>
    autocmd TermOpen * nnoremap <buffer> <c-r> i<c-r>

    " disable macros in terminal windows
    autocmd TermOpen * nnoremap <buffer> q <nop>
  elseif has('terminal')
    autocmd TerminalOpen * setlocal nolist nonumber norelativenumber sidescrolloff=0 scrolloff=0 winfixheight signcolumn=no
  endif
augroup END

if has('nvim')
  tnoremap <expr> <c-h> terminal#save_mode() . "\<c-w>h"
  tnoremap <expr> <c-j> terminal#save_mode() . "\<c-w>j"
  tnoremap <expr> <c-k> terminal#save_mode() . "\<c-w>k"
  tnoremap <expr> <c-l> terminal#save_mode() . "\<c-w>l"

  tnoremap <c-y> <c-\><c-n><c-y>
  tnoremap <c-u> <c-\><c-n><c-u>
elseif has('terminal')
  tnoremap <c-h> <c-w>h
  tnoremap <c-j> <c-w>j
  tnoremap <c-k> <c-w>k
  tnoremap <c-l> <c-w>l
  tnoremap <c-y> <c-\><c-n><c-y>
  tnoremap <c-u> <c-\><c-n><c-u>
  tnoremap <c-w> <c-w>.
endif

if has('eval')
  tnoremap <silent> <expr> <c-x>  terminal#save_mode() . ":TerminalToggle\<cr>"
  tnoremap <silent> <expr> <c-a>X terminal#save_mode() . ":TerminalToggle!\<cr>"

  nnoremap <silent> <c-x>            :TerminalToggle<cr>
  nnoremap <silent> <c-a>X           :TerminalToggle!<cr>
  inoremap <silent> <c-x>  <c-\><c-n>:TerminalToggle<cr>
  inoremap <silent> <c-a>X <c-\><c-n>:TerminalToggle!<cr>

  nnoremap <silent> <leader>t :call terminal#new()<cr>
endif
