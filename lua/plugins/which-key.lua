return {
	{
		"folke/which-key.nvim",
		cond = not vim.g.vscode,
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "buffer local keymaps (which-key)",
			},
		},
	},
}
