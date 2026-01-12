--[[
file-ops.lua - File System Operations and Environment

Plugins:
- vim-eunuch: Unix shell command helpers (Delete, Move, Chmod, etc.)
- direnv.vim: Automatic directory environment loading

Organization rule: Plugins for file operations and environment management (>50 lines)
See: lua/plugins/init.lua for placement guidelines
--]]

return {
	-- Unix shell command helpers for file operations
	{
		"tpope/vim-eunuch",
		cmd = {
			"Cfind",
			"Chmod",
			"Clocate",
			"Copy",
			"Delete",
			"Duplicate",
			"Lfind",
			"Llocate",
			"Mkdir",
			"Remove",
			"SudoEdit",
			"SudoWrite",
			"Unlink",
			"W",
			"Wall",
		},
		event = {
			"BufNewFile",
			"BufReadPost",
		},
		config = function()
			-- Custom commands that delegate to Snacks for better UX
			-- Move/Rename use Snacks.rename which provides live preview
			vim.api.nvim_create_user_command("Move", function()
				Snacks.rename.rename_file()
			end, { desc = "Move File" })

			vim.api.nvim_create_user_command("Rename", function()
				Snacks.rename.rename_file()
			end, { desc = "Rename File" })
		end,
	},

	-- Automatic directory environment loading via direnv
	{
		"direnv/direnv.vim",
		-- Temporary: using fork with fix for file descriptor leak during session restore
		-- The plugin spawned unlimited concurrent direnv jobs after 5 rapid BufEnter events
		-- TODO: Remove url/branch override once upstream merges the fix
		url = "https://github.com/joshuarubin/direnv.vim",
		branch = "fd-leak-fix",
		init = function()
			-- Silent load to avoid messages on every directory change
			vim.g.direnv_silent_load = 1
		end,
	},
}
