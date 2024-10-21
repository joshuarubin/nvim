return {
	{
		"folke/flash.nvim",
		keys = {
			{ "s", false },
			{ "S", false },
			{ "r", false },
			{ "R", false },
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
}
