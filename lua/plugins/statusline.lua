return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			extensions = { "neo-tree", "lazy", "toggleterm" },
		},
	},
}
