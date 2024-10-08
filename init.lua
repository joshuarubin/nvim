vim.o.termguicolors = true
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config")

-- these two lines must be last
vim.o.exrc = true -- enable per-directory .vimrc files
vim.o.secure = true -- disable unsafe commands in local .vimrc files
