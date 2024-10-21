return {
	{
		"folke/trouble.nvim",
		cond = not vim.g.vscode,
		keys = {
			{ "<leader>cs", false },
			{ "<leader>cS", false },
			{ "<leader>xL", false },
			{ "<leader>xQ", false },
			{
				"<leader>xs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>xd",
				"<cmd>Trouble lsp toggle<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xl",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xq",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
}
