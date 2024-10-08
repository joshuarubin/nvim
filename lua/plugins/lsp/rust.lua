return {
	{
		"mrcjkb/rustaceanvim",
		cond = not vim.g.vscode,
		version = "^5",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		init = function()
			vim.g.rustaceanvim = {
				server = {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				},
			}
		end,
	},
}
