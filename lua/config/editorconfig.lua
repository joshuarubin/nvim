if vim.g.vscode then
	return
end

local editorconfig = require("editorconfig")

editorconfig.properties.vim_filetype = function(bufnr, val)
	vim.bo[bufnr].filetype = val
end

local indent_size = editorconfig.properties.indent_size

---@diagnostic disable-next-line: duplicate-set-field
editorconfig.properties.indent_size = function(bufnr, val, opts)
	if vim.bo[bufnr].filetype == "go" then
		-- don't allow how tabs are "shown" to be configured for Go
		val = 4
	end
	---@diagnostic disable-next-line: param-type-mismatch
	indent_size(bufnr, val, opts)
end

local trim_trailing_whitespace = editorconfig.properties.trim_trailing_whitespace

---@diagnostic disable-next-line: duplicate-set-field
editorconfig.properties.trim_trailing_whitespace = function(bufnr, val)
	if vim.bo[bufnr].filetype == "go" then
		-- gopls will remove trailing whitespace
		val = "false"
	end
	trim_trailing_whitespace(bufnr, val)
end
