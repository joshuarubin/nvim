--[[
editing.lua - Core Text Editing Enhancements

Plugins:
- yanky.nvim: Enhanced yank/paste operations with history
- dial.nvim: Smart increment/decrement for various text objects
- mini.pairs: Automatic pair insertion and deletion

Organization rule: Small plugins (<50 lines) that enhance core text editing
See: lua/plugins/init.lua for placement guidelines
--]]

return {
	-- Enhanced yank/paste with clipboard history management
	{
		"gbprod/yanky.nvim",
		keys = {
			{ "p", "<Plug>(YankyPutBefore)", mode = { "x" }, desc = "Put Text Before Cursor" },
		},
	},

	-- Smart increment/decrement for numbers, dates, booleans, etc.
	{
		"monaqa/dial.nvim",
		keys = {
			{
				"+",
				function()
					require("dial.map").manipulate("increment", "normal")
				end,
				desc = "Increment",
			},
			{
				"=",
				"+",
				desc = "Increment",
				remap = true,
			},
			{
				"-",
				function()
					require("dial.map").manipulate("decrement", "normal")
				end,
				desc = "Decrement",
			},
			-- Disable default <c-a>/<c-x> mappings in favor of +/-
			{ "<c-a>", false, mode = { "n", "v" } },
			{ "<c-x>", false, mode = { "n", "v" } },
			{ "g<c-a>", false, mode = { "n", "v" } },
			{ "g<c-x>", false, mode = { "n", "v" } },
		},
	},

	-- Automatic pair insertion/deletion for brackets, quotes, etc.
	{
		"nvim-mini/mini.pairs",
		cond = not vim.g.vscode,
		opts = {
			modes = {
				-- Disable in command mode to avoid interference
				command = false,
			},
		},
	},

	-- Break bad vim habits by limiting repeated key usage
	-- {
	-- 	"m4xshen/hardtime.nvim",
	-- 	lazy = false,
	-- 	dependencies = { "MunifTanjim/nui.nvim" },
	-- 	opts = {},
	-- },
}
