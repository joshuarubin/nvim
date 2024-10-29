local snippets = require("luasnp.snippets")

local source = {}

---Invoke completion (required).
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
	local snips = snippets.get(params.context)

	local completion_items = vim.tbl_map(function(s)
		local body = ""
		if type(s.body) == "string" then
			body = s.body
		elseif type(s.body) == "function" then
			body = s.body(params.context)
		end

		---@type lsp.CompletionItem
		return {
			label = s.trigger,
			kind = vim.lsp.protocol.CompletionItemKind.Snippet,
			insertText = body,
			insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
		}
	end, snips)

	callback(completion_items)
end

return source
