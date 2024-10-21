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
	{
		"kevinhwang91/nvim-hlslens",
		cond = not vim.g.vscode,
		opts = {},
		keys = {
			{
				"n",
				"<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>",
				silent = true,
			},
			{
				"N",
				"<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
				silent = true,
			},
			{
				"*",
				"*<cmd>lua require('hlslens').start()<cr>",
			},
			{
				"#",
				"#<cmd>lua require('hlslens').start()<cr>",
			},
			{
				"g*",
				"g*<cmd>lua require('hlslens').start()<cr>",
				desc = "like '*' but don't limit to whole word matches",
			},
			{
				"g#",
				"g#<cmd>lua require('hlslens').start()<cr>",
				desc = "like '#' but don't limit to whole word matches",
			},
		},
	},
}
