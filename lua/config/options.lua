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
vim.o.backup = true
vim.o.backupcopy = "yes"
vim.o.backupdir = backupdir()
vim.o.listchars = "tab:│ ,trail:•,precedes:❮,nbsp:.,conceal:Δ"
vim.opt.fillchars = {
	diff = "╱", -- deleted lines of the 'diff' option
	eob = " ", -- empty lines at the end of a buffer
	fold = " ", -- filling 'foldtext'
	foldclose = "", -- show a closed fold
	foldopen = "", -- mark the beginning of a fold
	foldsep = " ", -- open fold middle marker
}
vim.o.foldcolumn = "auto:9"
vim.o.title = true
vim.o.showbreak = ""
vim.o.whichwrap = "b,s,<,>,[,]"
vim.o.breakindent = true
vim.o.shortmess = "filnxtToOFcIA"
vim.o.wildmode = "longest,full"
vim.o.wildignorecase = true
vim.o.wildignore = "*.o,*.obj,*~,*.so,*.swp,*.DS_Store" -- stuff to ignore when tab completing
vim.o.showfulltag = true
vim.o.diffopt = "internal,filler,closeoff,vertical,foldcolumn:0"
vim.o.winheight = 10
vim.o.concealcursor = ""
vim.o.showmode = false
vim.o.showtabline = 2 -- prevent flicker, lualine shows info anyway
vim.o.showcmd = false
vim.o.scrolljump = 3
vim.o.numberwidth = 1
vim.o.shiftround = true
vim.o.clipboard = "unnamedplus,unnamed" -- use clipboard register
vim.o.matchpairs = "(:),{:},[:],<:>"
vim.o.hidden = true -- hide buffers when they are abandoned
vim.o.infercase = true -- ignore case on insert completion
vim.o.grepprg = "rg --vimgrep --hidden --smart-case --follow"
vim.o.timeoutlen = 2000 -- time in milliseconds to wait for a mapped sequence to complete
vim.o.ttimeoutlen = 10 -- time in milliseconds to wait for a key code sequence to complete
vim.o.textwidth = 80
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.joinspaces = false
vim.o.tags = "./tags;/,~/.vimtags"
vim.o.mouse = "nv"
vim.o.spell = false
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.o.ruler = false
vim.o.wrap = true

vim.opt.packpath:prepend(vim.fn.stdpath("config"))
vim.opt.isfname:remove({ "=" })
vim.g.snacks_animate = false
vim.g.root_spec = { { ".git" }, "lsp", "cwd" }

require("config.env")
require("config.clipboard")
require("config.editorconfig")
require("config.abbrev")
require("config.filetype")
require("config.debug")
