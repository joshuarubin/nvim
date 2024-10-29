local M = {}

local global = require("luasnp.snippets.global")

---@param context cmp.Context
M.get = function(context)
	local snips = vim.list_slice(global)

	if not context.filetype then
		return snips
	end

	local ok, ftsnips = pcall(require, "luasnp.snippets." .. context.filetype)

	if not ok then
		return snips
	end

	vim.list_extend(snips, ftsnips)

	return snips
end

return M
