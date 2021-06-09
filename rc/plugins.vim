call plug#begin(rubix#config#dir('plugged'))

" enables surfing through buffers based on viewing history per window
Plug 'ton/vim-bufsurf'
nnoremap <silent> Z :BufSurfBack<cr>
nnoremap <silent> X :BufSurfForward<cr>

" shows recently used files, bookmarks and sessions
Plug 'mhinz/vim-startify'
let g:startify_session_dir = rubix#cache#dir('sessions')
let g:startify_show_sessions = 1
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_update_oldfiles = 1
let g:startify_session_sort = 1
let g:startify_custom_header = []
let g:startify_skiplist = add(
      \ map(split(&runtimepath, ','), 'escape(resolve(v:val . ''/doc''), ''\'')'),
      \ 'COMMIT_EDITMSG')
nnoremap <silent> <leader>bh :Startify<cr>

" quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" enable repeating supported plugin maps with `.`
Plug 'tpope/vim-repeat'

" helpers for unix
Plug 'tpope/vim-eunuch'

" wisely add "end" in ruby, endfunction/endif/more in vim script, etc.
Plug 'tpope/vim-endwise'
let g:endwise_no_mappings = 1 " called via snippets

" easy to use, file-type sensible comments
Plug 'tomtom/tcomment_vim'

Plug 'editorconfig/editorconfig-vim'
" has to be run before VimEnter or else `vim <file>` won't be set properly,
" though subsequent files will (if put in VimEnter)
try
  call editorconfig#AddNewHook(function('rubix#editorconfig#filetype_hook'))
catch /.*/
endtry

" vim search status
Plug 'osyo-manga/vim-anzu'
map n <plug>(anzu-n-with-echo)
map N <plug>(anzu-N-with-echo)

Plug 'nvim-treesitter/nvim-treesitter', rubix#plug#cond(has('nvim'), {'do': ':TSUpdate'})

" lsp
Plug 'neovim/nvim-lspconfig', rubix#plug#cond(has('nvim'))
Plug 'simrat39/rust-tools.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

" completion
Plug 'hrsh7th/nvim-compe'

" snippets
Plug 'hrsh7th/vim-vsnip'
let g:vsnip_snippet_dir = rubix#cache#dir('snippets')
Plug 'rafamadriz/friendly-snippets'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'folke/trouble.nvim'

Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_added = '█|'
let g:gitgutter_sign_modified = '█⫶'
let g:gitgutter_sign_removed = '█▁'
let g:gitgutter_sign_removed_first_line = '█▔'
let g:gitgutter_sign_modified_removed = "█▟"
let g:gitgutter_sign_priority = 9 " lower than the default 10 so lsp warn/error override
" need to call GitGutter to update signs after commiting with fugitive
" https://github.com/airblade/vim-gitgutter/issues/502
autocmd InitAutoCmd BufWritePost,WinEnter * GitGutter

" add file type icons for other plugins to use
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'

" the colorscheme
Plug 'cocopon/iceberg.vim'
Plug 'folke/lsp-colors.nvim'

" load larger plugin specific configuration
runtime! rc/plugins/*.vim

" Add plugins to &runtimepath, and:
call plug#end()

" install missing plugins on start
autocmd InitAutoCmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | quit
  \| endif
