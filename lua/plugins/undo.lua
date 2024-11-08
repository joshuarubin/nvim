return {
	{
		"simnalamburt/vim-mundo",
		cond = not vim.g.vscode,
		keys = {
			{
				"<leader>uu",
				":MundoToggle<cr>",
				silent = true,
				desc = "undo tree",
			},
		},
	},
}
