return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			dimInactive = false,
			terminalColors = true,
			background = {
				dark = "wave",
				light = "lotus",
			},
		},
	},
}
