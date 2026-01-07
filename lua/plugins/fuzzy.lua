--[[
fuzzy.lua - Fuzzy Finding and Window Selection

Plugins:
- fzf-lua: Fast fuzzy finder with custom keybindings

Organization rule: Fuzzy finding configuration (custom keybinds and overrides)
See: lua/plugins/init.lua for placement guidelines
--]]

return {
	-- Fast fuzzy finder with fzf integration
	{
		"ibhagwan/fzf-lua",
		cond = not vim.g.vscode,
		keys = {
			-- Disable default LazyVim keybindings that conflict with custom workflow
			{ "<leader>fc", false },
			{ "<leader>gs", false },
			{ "<leader>gc", false },
		},
	},
}
