local navigate = require("funcs.navigate")
local keys = {}

for dir, cmd in pairs({
	h = "NavigatorLeft",
	j = "NavigatorDown",
	k = "NavigatorUp",
	l = "NavigatorRight",
}) do
	-- normal, visual, terminal modes
	table.insert(keys, {
		"<c-" .. dir .. ">",
		navigate(dir, cmd),
		mode = { "n", "v", "t" },
		desc = cmd,
	})

	-- insert mode
	table.insert(keys, {
		"<c-" .. dir .. ">",
		navigate(dir, {
			insert = true,
			cmd = cmd,
		}),
		mode = "i",
		desc = cmd,
	})
end

return {
	{
		"numToStr/Navigator.nvim",
		cond = not vim.g.vscode,
		keys = keys,
		opts = {},
	},
}
