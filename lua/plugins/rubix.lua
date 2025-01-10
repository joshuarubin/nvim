return {
	{
		"joshuarubin/rubix.vim",
		config = true,
		cmd = {
			"A",
			"AS",
			"AV",
			"Only",
		},
		keys = {
			{
				"<leader>f$",
				":call rubix#trim()<cr>",
				silent = true,
				desc = "trim trailing whitespace",
			},
		},
	},
}
