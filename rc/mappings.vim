" leader mappings
nnoremap <silent> <leader>n :silent :nohlsearch<cr>

" find merge conflict markers
noremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<cr>

nnoremap <silent> <leader>q :qa<cr>
nnoremap <silent> <leader>Q :qa!<cr>

" <leader>cd: Switch to the directory of the open buffer
nnoremap <leader>cd :lcd %:p:h<cr>:pwd<cr>

" <leader>,: Switch to previous window
nnoremap <leader>p <c-w>p

" adjust viewports to the same size
noremap <leader>= <c-w>=

nnoremap <leader>fR :source $MYVIMRC<cr>

vnoremap <leader>s :sort<cr>

for s:i in range(1, 9)
  " <leader>[1-9] move to window [1-9]
  execute 'nnoremap <silent> <leader>'.s:i ' :'.s:i.'wincmd w<cr>'

  " <leader>b[1-9] move to buffer [1-9]
  execute 'nnoremap <silent> <leader>b'.s:i ':b'.s:i.'<cr>'
endfor
unlet s:i

cnoremap <c-j> <down>
cnoremap <c-k> <up>

" Q: Closes the window
nnoremap <silent> Q :q<cr>

" W: Save
nnoremap <silent> W :w<cr>

" _ : Quick horizontal splits
nnoremap <silent> _ :sp<cr>

" | : Quick vertical splits
nnoremap <silent> <bar> :vsp<cr>

" +/-: Increment number
nnoremap + <c-a>
nnoremap - <c-x>

" ctrl-w: Delete previous word, create undo point
inoremap <c-w> <c-g>u<c-w>

inoremap <expr> <down> pumvisible() ? "\<c-n>" : "\<down>"
inoremap <expr> <up>   pumvisible() ? "\<c-p>" : "\<up>"

" d: Delete into the blackhole register to not clobber the last yank
nnoremap d "_d

" dd: I use this often to yank a single line, retain its original behavior
nnoremap dd dd

" c: Change into the blackhole register to not clobber the last yank
nnoremap c "_c

" y: Yank and go to end of selection
xnoremap y y`]

" p: Paste in visual mode should not replace the default register with the deleted text
xnoremap p "_dP

" d: Delete into the blackhole register to not clobber the last yank. To 'cut', use 'x' instead
xnoremap d "_d

" enter: Highlight visual selections
xnoremap <silent> <cr> y:let @/ = @"<cr>:set hlsearch<cr>

" <|>: Reselect visual block after indent
xnoremap < <gv
xnoremap > >gv

" .: repeats the last command on every line
xnoremap . :normal.<cr>

" @: repeats macro on every line
xnoremap @ :normal@

" tab: Indent (allow recursive)
xmap <tab> >

" shift-tab: unindent (allow recursive)
xmap <s-tab> <

" ctrl-a r to redraw the screen now
noremap <silent> <c-a>r :redraw!<cr>

" ctrl-w to delete the current buffer without closing the window
nnoremap <silent> <c-w><c-w> :confirm :Kwbd<cr>

" tmux style navigation
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

vnoremap <c-h> <c-w>h
vnoremap <c-j> <c-w>j
vnoremap <c-l> <c-w>l
vnoremap <c-k> <c-w>k

inoremap <c-h> <esc><c-w>h
inoremap <c-l> <esc><c-w>l

inoremap <expr> <c-j> pumvisible() ? "\<c-n>" : "\<esc>\<c-w>j"
inoremap <expr> <c-k> pumvisible() ? "\<c-p>" : "\<esc>\<c-w>k"

" resize window
nnoremap <silent> <c-a>H <c-w><
nnoremap <silent> <c-a>L <c-w>>
nnoremap <silent> <c-a>J <c-w>+
nnoremap <silent> <c-a>K <c-w>-
vnoremap <silent> <c-a>H <c-w><
vnoremap <silent> <c-a>L <c-w>>
vnoremap <silent> <c-a>J <c-w>+
vnoremap <silent> <c-a>K <c-w>-
inoremap <silent> <c-a>H <esc><c-w><
inoremap <silent> <c-a>L <esc><c-w>>
inoremap <silent> <c-a>J <esc><c-w>+
inoremap <silent> <c-a>K <esc><c-w>-
tnoremap <silent> <c-a>H <c-\><c-n><c-w><
tnoremap <silent> <c-a>L <c-\><c-n><c-w>>
tnoremap <silent> <c-a>J <c-\><c-n><c-w>+
tnoremap <silent> <c-a>K <c-\><c-n><c-w>-

" NOTE <cr>, <tab> and <s-tab> completions are defined in lua/completion.lua

" show the completion popup
inoremap <silent><expr> <c-space> compe#complete()

" - if completion popup is showing:
"   - select completed value and switch to normal mode (note that this will not
"     do snippet completion because it is async and the switch to normal mode
"     happens first
" - else <esc>
" must be imap or else <esc> after iabbr doesn't expand
imap <expr> <silent> <esc> pumvisible() ? "\<c-y>\<esc>" : "\<esc>"

" abbreviations
iabbrev TODO TODO(jawa)
iabbrev meml me@jawa.dev
iabbrev weml joshua@ngrok.com
