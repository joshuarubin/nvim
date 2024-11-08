return {
	{
		"folke/zen-mode.nvim",
		cond = not vim.g.vscode,
		opts = {
			window = {
				width = 0.618,
			},
			plugins = {
				wezterm = {
					enabled = true,
					font = "+1", -- (10% increase per step)
				},
			},
		},
		keys = {
			{
				"<leader>m",
				":ZenMode<cr>",
				silent = true,
				desc = "toggle zen mode",
			},
		},
	},
}
