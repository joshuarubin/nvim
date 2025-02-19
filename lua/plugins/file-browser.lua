return {
	{
		"s1n7ax/nvim-window-picker",
		cond = not vim.g.vscode,
		name = "window-picker",
		event = "VeryLazy",
		version = "2.*",
		opts = {
			show_prompt = false,
			hint = "floating-big-letter",
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		cond = not vim.g.vscode,
		keys = {
			{
				"<c-n>",
				"<leader>fe",
				desc = "Explorer NeoTree (Root Dir)",
				remap = true,
			},
		},
		opts = {
			sources = { "filesystem" },
		},
	},
}
