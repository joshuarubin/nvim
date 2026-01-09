--[[
misc.lua - Miscellaneous Utilities

Plugins:
- jj-diffconflicts: Jujutsu merge conflict resolution helper
- vim-cedar: Cedar policy language syntax support

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
}
