-- ftplugin files are loaded before options.lua so they can get clobbered
-- autocmds.lua, also, isn't loaded yet when sessions are restored so FileType
-- autocmds don't run
-- this fixes both

local id
local create_callback = function(session)
	if session then
		vim.api.nvim_del_autocmd(id)
	end

	id = vim.api.nvim_create_autocmd("User", {
		desc = "rerun the FileType event",
		pattern = "VeryLazy",
		command = "doautoall FileType",
		once = true,
	})
end

vim.api.nvim_create_autocmd("SessionLoadPost", {
	pattern = "*",
	once = true,
	callback = function()
		create_callback(true)
	end,
})

create_callback(false)
