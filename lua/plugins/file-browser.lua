return {
	{
		"s1n7ax/nvim-window-picker",
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
		keys = {
			{
				"<c-n>",
				"<leader>fe",
				desc = "Explorer NeoTree (Root Dir)",
				remap = true,
			},
		},
	},
}
