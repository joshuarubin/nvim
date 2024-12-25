local go = require("luasnp.go")

return {
	{
		trigger = "ie",
		---@param context cmp.Context
		body = function(context)
			local ret = {
				"if err != nil {",
				"\t" .. go.return_values(context),
				"}$0",
			}
			return table.concat(ret, "\n")
		end,
	},
}
