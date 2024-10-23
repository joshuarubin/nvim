return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"typescript-language-server",
				"yamllint",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
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
