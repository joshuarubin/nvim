" simplify help navigation
nnoremap <buffer> <cr> <c-]>
nnoremap <buffer> <bs> <c-t>
nnoremap <buffer> o /'\l\{2,\}'<cr>
nnoremap <buffer> O ?'\l\{2,\}'<cr>
nnoremap <buffer> s /\|\zs\S\+\ze\|<cr>
nnoremap <buffer> S ?\|\zs\S\+\ze\|<cr>
nnoremap <buffer><silent> q :bw<cr>
