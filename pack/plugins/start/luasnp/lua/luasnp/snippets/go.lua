return {
	{
		trigger = "ie",
		---@param context cmp.Context
		body = function(context)
			local ok, go = pcall(require, "luasnp.go")
			local return_stmt = "return err"
			if ok then
				local result = go.return_values(context)
				if result ~= "" then
					return_stmt = result
				end
			end
			local ret = {
				"if err != nil {",
				"\t" .. return_stmt,
				"}$0",
			}
			return table.concat(ret, "\n")
		end,
	},
}
