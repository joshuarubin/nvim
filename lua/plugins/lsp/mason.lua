return {
	{
		"williamboman/mason.nvim",
		cond = not vim.g.vscode,
		opts = {
			ensure_installed = {
				"golines",
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
