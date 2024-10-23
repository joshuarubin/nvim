local function backupdir()
	local ret = vim.fn.stdpath("data") .. "/backup"
	if vim.fn.isdirectory(ret) ~= 1 then
		vim.fn.mkdir(ret, "p", "0700")
	end
	return ret
end

vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.o.shada = "!,'1000,<50,s10,h"
vim.o.dictionary = "/usr/share/dict/words"
vim.o.undofile = true -- persistent undo
vim.o.backup = true
vim.o.backupcopy = "yes"
vim.o.backupdir = backupdir()
vim.o.synmaxcol = 512
vim.o.list = true
vim.o.listchars = "tab:│ ,trail:•,precedes:❮,nbsp:.,conceal:Δ"
vim.o.fillchars = "vert:│,fold:-"
vim.o.foldcolumn = "auto:9"
vim.o.title = true
vim.o.linebreak = true -- wrap lines at convenient points
vim.o.showbreak = ""
vim.o.whichwrap = "b,s,<,>,[,]"
vim.o.breakindent = true
vim.o.shortmess = "filnxtToOFcI"
vim.o.wildmode = "longest,full"
vim.o.wildignorecase = true
vim.o.wildignore = "*.o,*.obj,*~,*.so,*.swp,*.DS_Store" -- stuff to ignore when tab completing
vim.o.showfulltag = true
vim.o.completeopt = "noinsert,menuone,noselect"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.diffopt = "internal,filler,closeoff,vertical,foldcolumn:0"
vim.o.winheight = 10
vim.o.conceallevel = 2
vim.o.concealcursor = ""
vim.o.showmode = false
vim.o.showtabline = 2 -- prevent flicker, lualine shows info anyway
vim.o.showcmd = false
vim.o.scrolloff = 8 -- start scrolling when we're 8 lines away from margins
vim.o.sidescrolloff = 15
vim.o.scrolljump = 3
vim.o.numberwidth = 1
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.clipboard = "unnamedplus,unnamed" -- use clipboard register
vim.o.matchpairs = "(:),{:},[:],<:>"
vim.o.hidden = true -- hide buffers when they are abandoned
vim.o.infercase = true -- ignore case on insert completion
vim.o.grepprg = "rg --with-filename --no-heading --line-number --column --hidden --smart-case --follow"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.timeoutlen = 2000
vim.o.ttimeoutlen = 10
vim.o.updatetime = 250
vim.o.virtualedit = "block"
vim.o.formatoptions = "jcroqlt"
vim.o.textwidth = 80
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.joinspaces = false
vim.o.smartindent = true
vim.o.ignorecase = true -- case insensitive matching
vim.o.smartcase = true -- smart case matching
vim.o.tags = "./tags;/,~/.vimtags"
vim.o.mouse = "nv"
vim.o.spell = false
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.o.guifont = "JetBrainsMono Nerd Font Rubix:h12"
vim.o.foldlevel = 99
vim.o.signcolumn = "yes"
vim.o.number = true -- line numbers are good

vim.opt.isfname:remove({ "=" })
