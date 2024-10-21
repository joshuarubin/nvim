vim.o.ruler = false

return {
	{
		"nvim-lualine/lualine.nvim",
		cond = not vim.g.vscode,
		opts = {
			options = {
				theme = "gruvbox_dark",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			extensions = { "neo-tree", "lazy", "toggleterm" },
		},
	},
}
