local global = require("luasnp.snippets.global")

local luasnp = {}

luasnp.new = function(opts)
	opts = opts or {}
	local self = setmetatable({}, { __index = luasnp })
	self.cache = {}
	self.registry = require("blink.cmp.sources.snippets.registry").new(opts)
	self.get_filetype = opts.get_filetype or function()
		return vim.bo.filetype
	end
	return self
end

function luasnp:snippet_to_completion_item(context, snippet)
	local luasnpCtx = {
		bufnr = context.bufnr,
		cursor = {
			line = context.cursor[1],
			col = context.cursor[2],
		},
	}

	local body = ""
	if type(snippet.body) == "string" then
		body = snippet.body
	elseif type(snippet.body) == "function" then
		body = snippet.body(luasnpCtx)
	else
		body = table.concat(snippet.body, "\n")
	end

	return {
		kind = require("blink.cmp.types").CompletionItemKind.Snippet,
		label = snippet.trigger,
		insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
		insertText = self.registry:expand_vars(body),
		description = snippet.description,
	}
end

local get_prev_word = function(context)
	local window = context.window or 0

	local row, col = unpack(vim.api.nvim_win_get_cursor(window))
	if col == 0 then
		return nil
	end

	-- move the cursor back one char so that the cursor is actually on a word
	vim.api.nvim_win_set_cursor(window, { row, col - 1 })

	-- this is so much simpler than trying to parse the line
	local word = vim.fn.expand("<cWORD>")

	-- and return the cursor to where it was
	vim.api.nvim_win_set_cursor(window, { row, col })

	context.cursor = { row - 1, col }

	return word
end

local expand_cache = luasnp.new()

function luasnp.expand(context)
	context = context or {}
	context.window = context.window or 0
	context.bufnr = context.bufnr or 0

	local trigger = get_prev_word(context)
	if not trigger then
		return false
	end

	local snip = expand_cache:get_by_trigger(trigger, context)
	if not snip then
		return false
	end

	-- remove the label from the buffer
	local row, col = unpack(context.cursor)
	local start_col = math.max(col - #trigger, 0)

	vim.schedule(function()
		vim.api.nvim_buf_set_text(0, row, start_col, row, col, {})
		vim.snippet.expand(snip)
	end)

	return true
end

function luasnp:get_by_trigger(trigger, context)
	local snippets = self:cache_completions(context)
	if snippets == nil then
		return false
	end

	local filtered = vim.tbl_filter(function(item)
		return item.trigger == trigger
	end, snippets)

	if not filtered or #filtered == 0 then
		return false
	end

	return self:snippet_to_completion_item(context, filtered[1]).insertText
end

function luasnp:cache_completions(context)
	local filetype = self.get_filetype(context)
	if vim.tbl_contains(self.registry.config.ignored_filetypes, filetype) then
		return nil
	end

	if not self.cache[filetype] then
		local global_snippets = vim.list_slice(global)
		local snips = vim.list_extend({}, global_snippets)

		if filetype then
			local ok, ft_snippets = pcall(require, "luasnp.snippets." .. filetype)
			if ok then
				vim.list_extend(snips, ft_snippets)
			end
		end

		self.cache[filetype] = snips
	end

	return self.cache[filetype]
end

function luasnp:get_completions(context, callback)
	local snippets = self:cache_completions(context)
	if snippets == nil then
		return callback()
	end

	local items = vim.tbl_map(function(snip)
		return self:snippet_to_completion_item(context, snip)
	end, snippets)

	callback({
		is_incomplete_forward = false,
		is_incomplete_backward = false,
		items = items,
	})
end

function luasnp:resolve(item, callback)
	local parsed_snippet = require("blink.cmp.sources.snippets.utils").safe_parse(item.insertText)
	local snippet = parsed_snippet and tostring(parsed_snippet) or item.insertText

	local resolved_item = vim.deepcopy(item)
	resolved_item.detail = snippet
	resolved_item.documentation = {
		kind = "markdown",
		value = item.description or "",
	}
	callback(resolved_item)
end

function luasnp:reload()
	self.cache = {}
end

return luasnp
