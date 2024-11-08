return {
	{
		"folke/edgy.nvim",
		cond = not vim.g.vscode,
		opts = {
			animate = {
				enabled = false,
			},
			options = {
				left = { size = 40 },
				right = { size = 40 },
			},
		},
	},
	{
		"folke/noice.nvim",
		cond = not vim.g.vscode,
		enabled = false,
		keys = {
			{ "<c-b>", false },
			{ "<c-f>", false },
		},
	},
	{
		"echasnovski/mini.indentscope",
		cond = not vim.g.vscode,
		opts = {
			draw = {
				animation = require("mini.indentscope").gen_animation.none(),
			},
		},
	},
	{
		"echasnovski/mini.icons",
		cond = not vim.g.vscode,
		opts = {
			filetype = {
				go = {
					glyph = "",
				},
			},
		},
	},
}
