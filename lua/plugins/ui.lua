return {
	{
		"folke/edgy.nvim",
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
		enabled = false,
		keys = {
			{ "<c-b>", false },
			{ "<c-f>", false },
		},
	},
	{
		"echasnovski/mini.indentscope",
		opts = {
			draw = {
				animation = require("mini.indentscope").gen_animation.none(),
			},
		},
	},
	{
		"echasnovski/mini.icons",
		opts = {
			filetype = {
				go = {
					glyph = "",
				},
			},
		},
	},
}
