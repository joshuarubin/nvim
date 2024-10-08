return {
	{
		"numToStr/Comment.nvim",
		config = function()
			local comment = require("Comment")
			comment.setup({})

			local ft = require("Comment.ft")
			ft.gomod = "//%s"
			ft.jsonnet = ft.get("go")
		end,
	},
	{
		"folke/todo-comments.nvim",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			keywords = {
				TODO = { icon = " ", color = "error" },
			},
			highlight = {
				keyword = "bg",
				pattern = [[.*<(KEYWORDS)\s*]],
			},
			search = {
				pattern = [[\b(KEYWORDS)]],
			},
		},
	},
}
