return {
	{
		"nvim-lualine/lualine.nvim",
		cond = not vim.g.vscode,
		opts = {
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
		},
	},
}
