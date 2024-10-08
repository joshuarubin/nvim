return {
	{
		"nvim-tree/nvim-tree.lua",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			disable_netrw = true,
			diagnostics = {
				enable = true,
				icons = {
					hint = " ",
					info = " ",
					warning = " ",
					error = " ",
				},
			},
			renderer = {
				highlight_git = true,
			},
			filters = {
				custom = { "^\\.git" },
			},
		},
		keys = {
			{
				"<c-n>",
				function()
					vim.api.nvim_command("NvimTreeFindFileToggle")
				end,
			},
			desc = "toggle file browser",
		},
	},
}
