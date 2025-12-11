return {
	{
		"joshuarubin/terminal.nvim",
		cond = not vim.g.vscode,
		opts = {
			mouse_preserve_mode = true,
		},
	},
}
