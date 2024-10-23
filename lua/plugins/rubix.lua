return {
	{
		"joshuarubin/rubix.vim",
		config = true,
		cmd = {
			"A",
			"AS",
			"AV",
			"Kwbd",
			"Only",
		},
		keys = {
			{
				"<leader>f$",
				":call rubix#trim()<cr>",
				silent = true,
				desc = "trim trailing whitespace",
			},
			{
				"<c-w><c-w>",
				":confirm :Kwbd<cr>",
				silent = true,
				desc = "delete the current buffer without closing the window",
			},
		},
	},
}
