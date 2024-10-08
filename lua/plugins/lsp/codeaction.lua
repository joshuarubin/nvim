return {
	{
		"kosayoda/nvim-lightbulb",
		cond = not vim.g.vscode,
		opts = {
			sign = {
				enabled = false,
			},
			virtual_text = {
				enabled = true,
			},
			autocmd = {
				enabled = true,
				pattern = { "*" },
				events = { "CursorHold", "CursorHoldI" },
			},
		},
	},
}
