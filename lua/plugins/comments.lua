return {
	{
		"folke/todo-comments.nvim",
		url = "https://github.com/joshuarubin/todo-comments.nvim",
		branch = "fix-extmark-errors",
		cond = not vim.g.vscode,
		opts = {
			highlight = {
				pattern = [[.*<(KEYWORDS)\s*]],
			},
			search = {
				pattern = [[\b(KEYWORDS)]],
			},
		},
	},
	{
		"folke/ts-comments.nvim",
		cond = not vim.g.vscode,
		opts = {
			lang = {
				editorconfig = "# %s",
			},
		},
	},
}
