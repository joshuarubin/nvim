return {
	{
		"ibhagwan/fzf-lua",
		cond = not vim.g.vscode,
		keys = {
			{ "<leader>gs", false },
			{ "<leader>gc", false },
		},
	},
}
