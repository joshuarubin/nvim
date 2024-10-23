return {
	{
		"tpope/vim-endwise",
		init = function()
			vim.g.endwise_no_mappings = 1
		end,
		lazy = false,
		keys = {
			{
				"<plug>Endwise",
				vim.api.nvim_replace_termcodes("<c-r>=EndwiseDiscretionary()<cr>", true, true, true),
				mode = "i",
				silent = true,
			},
		},
	},
}
