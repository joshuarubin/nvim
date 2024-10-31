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

	return vim.tbl_map(function(s)
		local body = ""
		if type(s.body) == "string" then
			body = s.body
		elseif type(s.body) == "function" then
			body = s.body(context)
		end

		---@type lsp.CompletionItem
		return {
			label = s.trigger,
			kind = vim.lsp.protocol.CompletionItemKind.Snippet,
			insertText = body,
			insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
		}
	end, snips)
end

---@param label string
---@param context cmp.Context
M.get_exact = function(label, context)
	local snips = M.get(context)
	for _, s in ipairs(snips) do
		if s.label == label then
			return s.insertText
		end
	end
end

return M
