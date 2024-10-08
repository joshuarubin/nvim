return {
	{
		"goolord/alpha-nvim", -- lua powered greeter like startify
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		priority = 100,
		opts = function()
			local startify = require("alpha.themes.startify")
			startify.file_icons.provider = "devicons"
			return startify.config
		end,
	},
}
