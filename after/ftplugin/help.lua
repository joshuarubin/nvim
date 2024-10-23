-- simplify help navigation
vim.keymap.set("n", "<cr>", "<c-]>", { buffer = 0 })
vim.keymap.set("n", "<bs>", "<c-t>", { buffer = 0 })
vim.keymap.set("n", "o", [[/'\l\{2,\}'<cr>]], { buffer = 0, silent = true })
vim.keymap.set("n", "O", [[?'\l\{2,\}'<cr>]], { buffer = 0, silent = true })
vim.keymap.set("n", "s", [[/|\zs\S\+\ze|<cr>]], { buffer = 0, silent = true })
vim.keymap.set("n", "S", [[?|\zs\S\+\ze|<cr>]], { buffer = 0, silent = true })
vim.keymap.set("n", "q", "bwipeout", { buffer = 0, expr = true })
