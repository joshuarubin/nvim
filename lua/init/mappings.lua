-- normal mode
vim.api.nvim_set_keymap("n", "<leader>n", ":silent :nohlsearch<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fc", "/\\v^[<|=>]{7}( .*|$)<cr>", {noremap = true}) -- find merge conflict markers
vim.api.nvim_set_keymap("n", "<leader>q", ":qa<cr>",  {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>Q", ":qa!<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>cd", ":lcd %:p:h<cr>:pwd<cr>", {noremap = true}) -- switch to the directory of the open buffer
vim.api.nvim_set_keymap("n", "<leader>p", "<c-w>p", {noremap = true}) -- switch to previous window
vim.api.nvim_set_keymap("n", "<leader>=", "<c-w>=", {}) -- adjust viewports to the same size
vim.api.nvim_set_keymap("v", "<leader>s", ":sort<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "Q", ":q<cr>", {silent = true, noremap = true}) -- Q: Closes the window
vim.api.nvim_set_keymap("n", "W", ":w<cr>", {silent = true, noremap = true}) -- W: Save
vim.api.nvim_set_keymap("n",     "_", ":sp<cr>",  {silent = true, noremap = true}) -- _: Quick horizontal splits
vim.api.nvim_set_keymap("n", "<bar>", ":vsp<cr>", {silent = true, noremap = true}) -- |: Quick vertical splits
vim.api.nvim_set_keymap("n", "+", "<c-a>", {noremap = true}) -- +: Increment number
vim.api.nvim_set_keymap("n", "-", "<c-x>", {noremap = true}) -- -: Decrement number
vim.api.nvim_set_keymap("n", "d", '"_d', {noremap = true}) -- d: Delete into the blackhole register to not clobber the last yank
vim.api.nvim_set_keymap("n", "dd", 'dd', {noremap = true}) -- dd: I use this often to yank a single line, retain its original behavior
vim.api.nvim_set_keymap("n", "c", '"_c', {noremap = true}) -- c: Change into the blackhole register to not clobber the last yank
vim.api.nvim_set_keymap("n", "<c-a>r", ":redraw!<cr>", {silent = true, noremap = true}) -- ctrl-a r to redraw the screen now
vim.api.nvim_set_keymap("n", "<c-h>", "<c-w>h", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("n", "<c-j>", "<c-w>j", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("n", "<c-k>", "<c-w>k", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("n", "<c-l>", "<c-w>l", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("n", "<c-a>H", "<c-w><", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("n", "<c-a>L", "<c-w>>", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("n", "<c-a>J", "<c-w>+", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("n", "<c-a>K", "<c-w>-", {noremap = true}) -- resize window

for i = 1, 9
do
  vim.api.nvim_set_keymap("n", "<leader>"..i,  ":"..i.."wincmd w<cr>", {silent = true, noremap = true}) -- <leader>[1-9]  move to window [1-9]
  vim.api.nvim_set_keymap("n", "<leader>b"..i, ":b"..i.."<cr>",        {silent = true, noremap = true}) -- <leader>b[1-9] move to buffer [1-9]
end

-- visual mode
vim.api.nvim_set_keymap("x", "y", 'y`]',  {noremap = true}) -- y: Yank and go to end of selection
vim.api.nvim_set_keymap("x", "p", '"_dP', {noremap = true}) -- p: Paste in visual mode should not replace the default register with the deleted text
vim.api.nvim_set_keymap("x", "d", '"_d',  {noremap = true}) -- d: Delete into the blackhole register to not clobber the last yank. To 'cut', use 'x' instead
vim.api.nvim_set_keymap("x", "<cr>", 'y:let @/ = @"<cr>:set hlsearch<cr>', {silent = true, noremap = true}) -- enter: Highlight visual selections
vim.api.nvim_set_keymap("x", "<", "<gv", {noremap = true}) -- <: Retain visual selection after indent
vim.api.nvim_set_keymap("x", ">", ">gv", {noremap = true}) -- >: Retain visual selection after indent
vim.api.nvim_set_keymap("x", ".", ":normal.<cr>",  {silent = true, noremap = true}) -- .: repeats the last command on every line
vim.api.nvim_set_keymap("x", "@", ":normal@@<cr>", {silent = true, noremap = true}) -- @: repeats the last macro on every line
vim.api.nvim_set_keymap("x", "<tab>",   ">", {}) -- tab: Indent (allow recursive)
vim.api.nvim_set_keymap("x", "<s-tab>", "<", {}) -- shift-tab: unindent (allow recursive)

-- visual and select mode
vim.api.nvim_set_keymap("v", "<c-h>", "<c-w>h", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("v", "<c-j>", "<c-w>j", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("v", "<c-k>", "<c-w>k", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("v", "<c-l>", "<c-w>l", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("v", "<c-a>H", "<c-w><", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("v", "<c-a>L", "<c-w>>", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("v", "<c-a>J", "<c-w>+", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("v", "<c-a>K", "<c-w>-", {noremap = true}) -- resize window

-- command line mode
vim.api.nvim_set_keymap("c", "<c-j>", "<down>", {noremap = true})
vim.api.nvim_set_keymap("c", "<c-k>", "<up>",   {noremap = true})

-- insert mode
vim.api.nvim_set_keymap("i", "<c-w>", "<c-g>u<c-w>", {noremap = true}) -- ctrl-w: Delete previous word, create undo point
vim.api.nvim_set_keymap("i", "<c-h>", "<esc><c-w>h", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("i", "<c-l>", "<esc><c-w>l", {noremap = true}) -- tmux style navigation
vim.api.nvim_set_keymap("i", "<c-j>", 'pumvisible() ? "<c-n>" : "<esc><c-w>j"', {noremap = true, expr = true}) -- tmux style navigation
vim.api.nvim_set_keymap("i", "<c-k>", 'pumvisible() ? "<c-p>" : "<esc><c-w>k"', {noremap = true, expr = true}) -- tmux style navigation
vim.api.nvim_set_keymap("i", "<c-a>H", "<esc><c-w><i", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("i", "<c-a>L", "<esc><c-w>>i", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("i", "<c-a>J", "<esc><c-w>+i", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("i", "<c-a>K", "<esc><c-w>-i", {noremap = true}) -- resize window

-- terminal mode
vim.api.nvim_set_keymap("t", "<c-a>H", "<c-\\><c-n><c-w><i", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("t", "<c-a>L", "<c-\\><c-n><c-w>>i", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("t", "<c-a>J", "<c-\\><c-n><c-w>+i", {noremap = true}) -- resize window
vim.api.nvim_set_keymap("t", "<c-a>K", "<c-\\><c-n><c-w>-i", {noremap = true}) -- resize window

-- abbreviations
vim.cmd [[iabbrev TODO TODO(jawa)]]
vim.cmd [[iabbrev meml me@jawa.dev]]
vim.cmd [[iabbrev weml joshua@ngrok.com]]
