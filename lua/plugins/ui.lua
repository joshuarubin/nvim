return {
	{
		"lukas-reineke/indent-blankline.nvim",
		cond = not vim.g.vscode,
	},
	{
		"stevearc/dressing.nvim",
		cond = not vim.g.vscode,
		opts = {},
	},
	{
		"folke/noice.nvim",
		cond = not vim.g.vscode,
		keys = {
			{ "<c-b>", false },
			{ "<c-f>", false },
		},
	},
}
