scriptencoding utf-8

if has('shada')
  set shada=!,'1000,<50,s10,h
endif

if has('viminfo')
  set viminfo='1000,<50,s10,h
endif

set encoding=utf-8 " set encoding for text
set dictionary=/usr/share/dict/words
set regexpengine=1

" persistent undo
if has('persistent_undo')
  set undofile
endif

" backups
set backup
set backupcopy=yes

let s:backupdir = stdpath('data')..'/backup'
if !isdirectory(s:backupdir)
  call mkdir(s:backupdir, "p", 0700)
endif
let &backupdir=s:backupdir

let g:mapleader = ','

" prefer locally installed python
if executable('/usr/local/bin/python')
  let g:python_host_prog = '/usr/local/bin/python'
endif

if executable('/usr/local/bin/python3')
  let g:python3_host_prog = '/usr/local/bin/python3'
endif

set synmaxcol=512

if has('syntax')
  syntax sync minlines=256
endif

set list

set listchars=tab:\│\ ,trail:•,precedes:❮,nbsp:.
set fillchars=vert:│,fold:-

set laststatus=2 " always show the statusline
set title
set linebreak " wrap lines at convenient points
let &showbreak='=>'

set whichwrap+=<,>,[,]

if exists('+breakindent')
  set breakindent
  set wrap
else
  set nowrap
endif

set shortmess+=Ic
set t_vb=
set novisualbell " no sounds

set wildmenu " show list for autocomplete
set wildmode=list:longest,full

if v:version > 703 || v:version == 703 && has('patch072')
  set wildignorecase
endif

" stuff to ignore when tab completing
set wildignore+=
      \*.o,
      \*.obj,
      \*~,
      \*.so,
      \*.swp,
      \*.DS_Store

set history=1000 " store lots of :cmdline history
set showfulltag
set completeopt=noinsert,menuone,noselect
set nospell
set splitright
set splitbelow
set diffopt+=vertical
set winheight=10
set winminheight=1
set ttyfast " assume fast terminal connection
set lazyredraw

if has('conceal')
  set conceallevel=2
  set concealcursor=niv
  set listchars+=conceal:Δ
endif

set noshowmode
set showtabline=2

set ruler
set noshowcmd                   " prevent flicker, lightline shows info anyway
set number " line numbers are good

set scrolloff=8                 " start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
set scrolljump=3
set numberwidth=1
set cursorline
set signcolumn=number
set smarttab
set expandtab
set shiftround
set modeline

" use clipboard register
if has('clipboard')
  set clipboard=unnamed

  if has('unnamedplus')
    set clipboard=unnamedplus,unnamed
  endif
endif

set backspace=indent,eol,start  " allow backspace in insert mode
set noshowmatch                 " don't show matching brackets
set cpoptions-=m
set matchtime=2                 " tens of a second to show matching parentheses
set matchpairs+=<:>
set hidden                      " hide buffers when they are abandoned
set autoread                    " reload files changed outside vim
set infercase                   " ignore case on insert completion

if executable('rg')
  set grepprg=rg\ --with-filename\ --no-heading\ --line-number\ --column\ --hidden\ --smart-case\ --follow
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -inH
endif

set isfname-== " exclude = from isfilename.

set timeout timeoutlen=2000 ttimeoutlen=10
set updatetime=300
set virtualedit=block

set autoindent
set nrformats-=octal " always assume decimal numbers

set formatoptions=croqlt

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j " Delete comment character when joining commented lines
endif

set textwidth=80
set shiftwidth=2
set tabstop=2
set softtabstop=2
set nojoinspaces
set smartindent
set nocopyindent

" search
set ignorecase " case insensitive matching
set smartcase  " smart case matching
set incsearch  " incremental search
set hlsearch
set wrapscan

set tags=./tags;/,~/.vimtags

if has('mouse')
  set mouse=nv
  set mousehide
endif
