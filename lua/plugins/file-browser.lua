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
				highlight_opened_files = "all",
			},
			filters = {
				custom = { "^\\.git" },
			},
			update_focused_file = {
				enable = true,
				update_root = {
					enable = true,
				},
			},
			prefer_startup_root = true,
			sync_root_with_cwd = true,
			respect_buf_cwd = false,
			reload_on_bufenter = true,
		},
		keys = {
			{
				"<c-n>",
				function()
					vim.api.nvim_command("NvimTreeFindFileToggle!")
				end,
			},
			desc = "toggle file browser",
		},
	},
}
