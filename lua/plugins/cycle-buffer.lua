return {
	{
		"joshuarubin/cybu.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		branch = "buf-history-order",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			display_time = 1500,
			style = {
				highlights = {
					current_buffer = "Comment",
					adjacent_buffers = "Visual",
				},
			},
		},
		keys = {
			{
				"Z",
				function()
					require("cybu").cycle("prev")
				end,
				desc = "cycle to previous buffer in window",
			},
			{
				"X",
				function()
					require("cybu").cycle("next")
				end,
				desc = "cycle to next buffer in window",
			},
		},
	},
}
