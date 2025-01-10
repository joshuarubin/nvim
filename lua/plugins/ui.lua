return {
	{
		"folke/edgy.nvim",
		cond = not vim.g.vscode,
		opts = {
			animate = {
				enabled = false,
			},
			options = {
				left = { size = 40 },
				right = { size = 40 },
			},
		},
	},
	{
		"folke/noice.nvim",
		cond = not vim.g.vscode,
		opts = {
			cmdline = {
				view = "cmdline",
			},
			presets = {
				command_palette = false,
				lsp_doc_border = true,
				inc_rename = false,
			},
		},
		keys = {
			{ "<c-b>", false },
			{ "<c-f>", false },
		},
	},
	{
		"echasnovski/mini.icons",
		cond = not vim.g.vscode,
		opts = {
			filetype = {
				go = {
					glyph = "",
				},
			},
		},
	},
}
