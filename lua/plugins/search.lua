return {
	{
		"folke/flash.nvim",
		keys = {
			{ "s", false, mode = { "n", "o", "x" } },
			{ "S", false, mode = { "n", "o", "x" } },
			{ "r", false, mode = { "o" } },
			{ "R", false, mode = { "o", "x" } },
		},
		opts = {
			modes = {
				char = {
					highlight = {
						backdrop = false,
					},
				},
			},
		},
	},
}
