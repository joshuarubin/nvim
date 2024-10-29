return {
	{
		"folke/todo-comments.nvim",
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
		opts = {
			lang = {
				editorconfig = "# %s",
			},
		},
	},
}
