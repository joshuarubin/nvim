return {
	{
		"folke/snacks.nvim",
		opts = {
			terminal = {
				-- this is needed for terminal.nvim to work
				interactive = false,
			},
			words = {
				enabled = false,
			},
			styles = {
				terminal = {
					keys = {
						q = "<nop>",
						term_normal = "<nop>",
					},
				},
			},
		},
	},
}
