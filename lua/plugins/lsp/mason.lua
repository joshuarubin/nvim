return {
	{
		"williamboman/mason.nvim",
		cond = not vim.g.vscode,
		opts = {
			ensure_installed = {
				"typescript-language-server",
				"yamllint",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		cond = not vim.g.vscode,
		opts = {
			automatic_installation = {
				exclude = {
					"clangd",
					"rust-analyzer",
					"zls",
				},
			},
		},
	},
}
