return {
	{
		"mason-org/mason.nvim",
		cond = not vim.g.vscode,
		opts = {
			ensure_installed = {
				"cuelsp",
				"golines",
				"tree-sitter-cli",
				"typescript-language-server",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
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
