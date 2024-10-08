return {
	{
		"simnalamburt/vim-mundo",
		cond = not vim.g.vscode,
		keys = {
			{
				"<leader>u",
				":MundoToggle<cr>",
				silent = true,
				desc = "undo tree",
			},
		},
	},
}
