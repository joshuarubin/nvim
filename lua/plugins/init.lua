--[[
init.lua - Lazy.nvim Bootstrap and Core Framework

This file contains only the core plugin manager (lazy.nvim) and framework (LazyVim).
All other plugins are organized in separate files by category.

## Plugin Organization

Plugin files are organized by theme/purpose:
- editing.lua: Text editing enhancements (yanky, dial, mini.pairs)
- ui.lua: Visual/UI plugins (edgy, noice, lualine, snacks, render-markdown, flatten)
- git.lua: Git/VCS integration (neogit, diffview, gitsigns, hunk, lazyjj)
- completion.lua: Completion engine (blink.cmp)
- file-ops.lua: File operations (vim-eunuch, direnv)
- fuzzy.lua: Fuzzy finding (fzf-lua)
- testing.lua: Testing and API tools (kulala)
- colorscheme.lua: Color schemes (lazy-loaded)
- ai.lua: AI assistants
- treesitter.lua: Syntax parsing
- lsp/: Language server configurations
- misc.lua: Uncategorized utilities (terminal.nvim, vim-mundo, jj-diffconflicts, vim-cedar)

## Plugin Placement Guidelines

When adding a new plugin, follow these rules:

1. Determine size and complexity:
   - Simple (<20 lines): Add to appropriate themed file or misc.lua
   - Medium (20-50 lines): Add to themed file if it fits, or create new file
   - Large (>50 lines) or complex: Create dedicated file

2. Check for thematic fit:
   - Does it relate to git/VCS? → git.lua
   - Is it UI/visual? → ui.lua
   - Is it for editing text? → editing.lua
   - Is it for testing/API? → testing.lua
   - Is it for file operations? → file-ops.lua
   - Is it LSP-related? → lsp/ subdirectory
   - None of the above? → misc.lua

3. Follow existing patterns:
   - Add documentation header to file
   - Use clear inline comments
   - Include `desc` fields for all keymaps
   - Document non-obvious configuration choices

See: lua/plugins/README.md for complete organization guide
--]]

return {
	-- Lazy.nvim plugin manager
	{
		"folke/lazy.nvim",
		version = false,
	},

	-- LazyVim framework
	{
		"LazyVim/LazyVim",
		version = false,
		opts = {
			colorscheme = "tokyonight",
			news = {
				lazyvim = false,
				neovim = false,
			},
			icons = {
				kinds = {
					Snippet = " ",
				},
			},
		},
	},
}
