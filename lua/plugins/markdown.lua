return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "norg", "rmd", "org", "Avante", "codecompanion" },
		cond = not vim.g.vscode,
		opts = {
			win_options = {
				conceallevel = {
					default = 3,
					rendered = 3,
				},
			},
		},
	},
}
