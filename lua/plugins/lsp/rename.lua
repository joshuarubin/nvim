return {
	{
		"smjonas/inc-rename.nvim",
		cond = not vim.g.vscode,
		dependencies = {
			"stevearc/dressing.nvim",
		},
		opts = {
			input_buffer_type = "dressing",
		},
		keys = {
			{
				"<leader>cr",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				expr = true,
				desc = "incremental rename",
			},
		},
	},
}
