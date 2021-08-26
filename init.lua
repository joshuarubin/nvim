require('init/settings')
require('init/plugins')
require('init/treesitter')
require('init/lsp')
require('init/completion')
require('init/telescope')
require('init/trouble')
require('init/mappings')
require('init/commands')

vim.o.exrc   = true -- enable per-directory .vimrc files
vim.o.secure = true -- disable unsafe commands in local .vimrc files
