vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	once = true,
	callback = function()
		local names = {
			"LazyNormal",
			"EdgyNormal",
			"NeoTreeFloatNormal",
		}
		for _, name in ipairs(names) do
			vim.api.nvim_set_hl(0, name, { default = true, link = "Normal" })
		end
	end,
})

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
			wo = {
				winhighlight = "WinBar:EdgyWinBar",
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
}
