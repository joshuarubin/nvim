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
	})

	-- insert mode
	table.insert(keys, {
		"<c-" .. dir .. ">",
		navigate(dir, {
			insert = true,
			cmd = cmd,
		}),
		mode = "i",
	})
end

return {
	{
		"numToStr/Navigator.nvim",
		keys = keys,
		opts = {},
	},
}
