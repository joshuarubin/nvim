--[[
history.lua - Terminal and Undo History Management

Plugins:
- terminal.nvim: Enhanced terminal integration
- vim-mundo: Visual undo tree navigation

Organization rule: Small plugins (<50 lines) that manage history (undo, terminal)
See: lua/plugins/init.lua for placement guidelines
--]]

return {
	-- Enhanced terminal integration with better window management
	{
		"joshuarubin/terminal.nvim",
		cond = not vim.g.vscode,
		opts = {},
	},

	-- Visual undo tree for navigating edit history
	{
		"simnalamburt/vim-mundo",
		cond = not vim.g.vscode,
		keys = {
			{
				"<leader>uu",
				":MundoToggle<cr>",
				silent = true,
				desc = "Undo Tree",
			},
		},
	},
}
