-- Markdown filetype settings
-- Override global defaults (2 spaces) with wider indentation
-- Disable textwidth to avoid unwanted line wrapping
-- Enable spell checking for prose

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true -- Use spaces for better compatibility
vim.bo.textwidth = 0 -- Disable automatic line wrapping
vim.bo.spelllang = "en_us"
