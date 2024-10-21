return {
	{
		"SmiteshP/nvim-navic",
		cond = not vim.g.vscode,
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
	{
		"utilyre/barbecue.nvim",
		cond = not vim.g.vscode,
		dependencies = {
			"SmiteshP/nvim-navic",
		},
		opts = {},
	},
}
