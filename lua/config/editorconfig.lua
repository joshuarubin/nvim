local editorconfig = require("editorconfig")

editorconfig.properties.vim_filetype = function(bufnr, val, opts)
	vim.bo[bufnr].filetype = val
end
