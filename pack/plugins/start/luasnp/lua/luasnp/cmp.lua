local snippets = require("luasnp.snippets")

local source = {}

---Invoke completion (required).
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
	local snips = snippets.get(params.context)
	callback(snips)
end

return source
