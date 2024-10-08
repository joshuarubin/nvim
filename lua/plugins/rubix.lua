local keys = {
	{
		"<leader>f$",
		":call rubix#trim()<cr>",
		silent = true,
		desc = "trim trailing whitespace",
	},
}

if not vim.g.vscode then
	table.insert(keys, {
		"<leader>fa",
		":call rubix#preserve('normal gg=G')<cr>",
		silent = true,
	})

	table.insert(keys, {
		"<c-w><c-w>",
		":confirm :Kwbd<cr>",
		silent = true,
		desc = "delete the current buffer without closing the window",
	})
end

return {
	{
		"joshuarubin/rubix.vim",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		opts = {},
		keys = keys,
	},
}
