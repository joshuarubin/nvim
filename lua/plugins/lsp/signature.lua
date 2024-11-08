return {
	{
		"ray-x/lsp_signature.nvim",
		cond = not vim.g.vscode,
		event = "VeryLazy",
		opts = {},
	},
}
