local init_group = vim.api.nvim_create_augroup("InitAutoCmd", {})

vim.api.nvim_create_autocmd("InsertEnter", {
	desc = "disable search highlighting in insert mode",
	group = init_group,
	pattern = "*",
	command = "setlocal nohlsearch",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "enable search highlighting when leaving insert mode",
	group = init_group,
	pattern = "*",
	command = "setlocal hlsearch",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight on yank",
	group = init_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("WinEnter", {
	desc = "check timestamp more for 'autoread'",
	group = init_group,
	pattern = "*",
	command = "checktime",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "disable paste",
	group = init_group,
	pattern = "*",
	command = "if &paste | set nopaste | echo 'nopaste' | endif",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "update diff",
	group = init_group,
	pattern = "*",
	command = "if &l:diff | diffupdate | endif",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "go back to previous position of cursor if any",
	group = init_group,
	pattern = "*",
	callback = function()
		local prev_line = vim.api.nvim_buf_get_mark(0, '"')[1]

		if prev_line > 0 and prev_line <= vim.api.nvim_buf_line_count(0) then
			local go_to_prev_mark = 'g`"'
			local open_folds = "zv"
			local redraw_line = "zz"
			vim.cmd("normal!" .. go_to_prev_mark .. open_folds .. redraw_line)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "set showbreak",
	group = init_group,
	pattern = "*",
	callback = function()
		vim.wo.showbreak = "=>"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "disable showbreak for markdown files",
	group = init_group,
	pattern = { "markdown", "norg", "rmd", "org", "Avante" },
	callback = function()
		vim.wo.showbreak = ""
	end,
})

-- terminal autocommands
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "switch to insert mode and press up when in terminal normal mode",
	pattern = "*",
	command = "nnoremap <buffer> <up> i<up>",
})

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "switch to insert mode and press <c-r> when in terminal normal mode",
	pattern = "*",
	command = "nnoremap <buffer> <c-r> i<c-r>",
})

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "disable macros in terminals",
	pattern = "*",
	command = "nnoremap <buffer> q <nop>",
})
