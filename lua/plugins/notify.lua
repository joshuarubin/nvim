return {
	{
		"rcarriga/nvim-notify",
		cond = not vim.g.vscode,
		init = function()
			vim.notify = require("notify")
		end,
		opts = {},
	},
}
