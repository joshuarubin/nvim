function! has#colorscheme(name) abort
  let l:pat = 'colors/'.a:name.'.vim'
  return !empty(globpath(&runtimepath, l:pat))
endfunction
