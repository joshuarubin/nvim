return {
	{
		"ibhagwan/fzf-lua",
		cond = not vim.g.vscode,
		keys = {
			{ "<leader>fc", false },
			{ "<leader>gs", false },
			{ "<leader>gc", false },
		},
	},
}
