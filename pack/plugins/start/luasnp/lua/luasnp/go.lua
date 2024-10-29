local ts_utils = require("nvim-treesitter.ts_utils")
local parsers = require("nvim-treesitter.parsers")

local M = {}

M.split_args = function(text)
	local args
	if text ~= nil and text:sub(1, 1) == "(" then
		text = text:sub(2, -2)
		args = vim.split(text, ",")
	else
		args = { text }
	end

	for i, arg in pairs(args) do
		local spl = vim.split(arg, " +")
		if table.maxn(spl) > 1 then
			arg = spl[2]
		end
		args[i] = vim.trim(arg)
	end

	return args
end

M.zero_value = function(type)
	if type == "error" then
		return "err"
	end

	-- pointers and slices
	local first = type:sub(1, 1)
	if first == "*" or first == "[" or type == "any" or type == "interface{}" then
		return "nil"
	end

	if type == "bool" then
		return "false"
	end

	if type == "string" then
		return '""'
	end

	if
		type == "int"
		or type == "int8"
		or type == "int16"
		or type == "int32"
		or type == "int64"
		or type == "uint"
		or type == "uint8"
		or type == "uint16"
		or type == "uint32"
		or type == "uint64"
		or type == "float32"
		or type == "float64"
		or type == "complex64"
		or type == "complex128"
		or type == "uintptr"
		or type == "byte"
		or type == "rune"
	then
		return "0"
	end

	-- default to nil, works for maps and interfaces
	-- doesn't work for struct types
	return "nil"
end

---@param context cmp.Context
---@return string
M.return_values = function(context)
	local root_lang_tree = parsers.get_parser(context.bufnr)
	local ret = ""

	if not root_lang_tree then
		return ret
	end

	local root = ts_utils.get_root_for_position(context.cursor.line, context.cursor.col, root_lang_tree)

	if not root then
		return ret
	end

	local node = root:named_descendant_for_range(
		context.cursor.line,
		context.cursor.col,
		context.cursor.line,
		context.cursor.col
	)

	while node ~= nil do
		if
			node:type() == "function_declaration"
			or node:type() == "func_literal"
			or node:type() == "method_declaration"
		then
			break
		end
		node = node:parent()
	end

	if node == nil then
		return ret
	end

	local nodes = node:field("result")
	if nodes == nil then
		return ret
	end

	ret = "return"

	local result = nodes[1]
	if result == nil then
		return ret
	end

	-- text can be a single value like "float64" or "error"
	-- or a list
	local text = vim.treesitter.get_node_text(result, 0)

	local results = M.split_args(text)

	for i, arg in pairs(results) do
		if i ~= 1 then
			ret = ret .. ","
		end
		ret = ret .. " " .. M.zero_value(arg)
	end

	return ret
end

return M
