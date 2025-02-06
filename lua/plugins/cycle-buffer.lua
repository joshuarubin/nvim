return {
	{
		"akinsho/bufferline.nvim",
		keys = {
			{ "<s-h>", false },
			{ "<s-l>", false },
			{ "[b", false },
			{ "]b", false },
		},
	},
	{
		"joshuarubin/cybu.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		branch = "buf-history-order",
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
				desc = "Prev Buffer",
			},
			{
				"H",
				function()
					require("cybu").cycle("prev")
				end,
				desc = "Prev Buffer",
			},
			{
				"[b",
				function()
					require("cybu").cycle("prev")
				end,
				desc = "Prev Buffer",
			},
			{
				"X",
				function()
					require("cybu").cycle("next")
				end,
				desc = "Next Buffer",
			},
			{
				"L",
				function()
					require("cybu").cycle("next")
				end,
				desc = "Next Buffer",
			},
			{
				"]b",
				function()
					require("cybu").cycle("next")
				end,
				desc = "Next Buffer",
			},
		},
	},
}
