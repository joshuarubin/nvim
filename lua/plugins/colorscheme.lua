return {
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
		init = function()
			vim.cmd([[colorscheme kanagawa]])
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		cond = not vim.g.vscode,
		opts = {
			"*",
		},
	},
}
