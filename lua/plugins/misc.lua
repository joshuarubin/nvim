--[[
misc.lua - Miscellaneous Utilities

Plugins:
- jj-diffconflicts: Jujutsu merge conflict resolution helper
- vim-cedar: Cedar policy language syntax support
- terminal.nvim: Enhanced terminal integration
- vim-mundo: Visual undo tree navigation

Organization rule: Small, uncategorized utilities that don't fit other themes
See: lua/plugins/init.lua for placement guidelines
--]]

return {
	-- Jujutsu (jj) merge conflict resolution helper
	{
		"rafikdraoui/jj-diffconflicts",
		cmd = { "JJDiffConflicts" },
		init = function()
			require("util.jj").setup_diffconflicts()
		end,
	},

	-- Cedar policy language syntax highlighting
	{
		"Dzordzu/vim-cedar",
	},

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
