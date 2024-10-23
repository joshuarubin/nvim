return {
	{
		"kosayoda/nvim-lightbulb",
		opts = {
			sign = {
				enabled = false,
			},
			virtual_text = {
				enabled = true,
			},
			autocmd = {
				enabled = true,
				pattern = { "*" },
				events = { "CursorHold", "CursorHoldI" },
			},
		},
	},
}
