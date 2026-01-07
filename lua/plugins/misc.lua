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
	-- TODO(joshua): Add configuration or usage notes
	{
		"rafikdraoui/jj-diffconflicts",
		cmd = { "JJDiffConflicts" },
	},

	-- Cedar policy language syntax highlighting
	{
		"Dzordzu/vim-cedar",
	},
}
