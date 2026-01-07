-- Go filetype settings
-- Override global defaults (2 spaces) with Go conventions
-- Go standard: tabs for indentation, 100-char textwidth

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = false -- Use actual tab characters (Go standard)
vim.bo.textwidth = 100 -- Wrap at 100 characters
