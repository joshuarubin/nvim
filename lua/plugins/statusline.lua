vim.o.ruler = false

return {
	{
		"nvim-lualine/lualine.nvim",
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
