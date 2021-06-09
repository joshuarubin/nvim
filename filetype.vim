if exists('did_load_filetypes')
  finish
endif

augroup filetypedetect
  " TypeScript
  autocmd BufNewFile,BufRead *.ts  set filetype=typescript
  autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx

  " JavaScript
  autocmd BufNewFile,BufRead *.es6 set filetype=javascript

  " .envrc
  autocmd BufNewFile,BufRead .envrc set filetype=sh

  " .nix
  autocmd BufNewFile,BufRead *.nix set filetype=nix
augroup END
