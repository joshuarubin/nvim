-- Help filetype settings
-- Custom navigation keybindings for easier help file browsing
-- Optimized for quick tag jumping and searching

-- Navigate tags
vim.keymap.set("n", "<cr>", "<c-]>", { buffer = 0, desc = "Follow tag" })
vim.keymap.set("n", "<bs>", "<c-t>", { buffer = 0, desc = "Go back" })

-- Search for options (wrapped in single quotes)
vim.keymap.set("n", "o", [[/'\l\{2,\}'<cr>]], { buffer = 0, silent = true, desc = "Next option" })
vim.keymap.set("n", "O", [[?'\l\{2,\}'<cr>]], { buffer = 0, silent = true, desc = "Previous option" })

-- Search for subjects (wrapped in pipes)
vim.keymap.set("n", "s", [[/|\zs\S\+\ze|<cr>]], { buffer = 0, silent = true, desc = "Next subject" })
vim.keymap.set("n", "S", [[?|\zs\S\+\ze|<cr>]], { buffer = 0, silent = true, desc = "Previous subject" })

-- Quick close
vim.keymap.set("n", "q", "bwipeout", { buffer = 0, expr = true, desc = "Close help" })
