return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
	},
	{
		"rebelot/kanagawa.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		opts = {
			dimInactive = false,
			terminalColors = true,
			background = {
				dark = "wave",
				light = "lotus",
			},
		},
	},
	{
		"norcalli/nvim-colorizer.lua",
		cond = not vim.g.vscode,
		opts = {
			"*",
		},
	},
}
