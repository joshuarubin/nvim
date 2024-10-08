local safe_require = require("funcs.safe_require")

local init_group = vim.api.nvim_create_augroup("InitAutoCmd", {})

vim.api.nvim_create_autocmd("InsertEnter", {
	desc = "disable search highlighting in insert mode",
	group = init_group,
	pattern = "*",
	command = "setlocal nohlsearch",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "enable search highlighting when leaving insert mode",
	group = init_group,
	pattern = "*",
	command = "setlocal hlsearch",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight on yank",
	group = init_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

if vim.g.vscode then
	return
end

vim.api.nvim_create_autocmd("WinEnter", {
	desc = "check timestamp more for 'autoread'",
	group = init_group,
	pattern = "*",
	command = "checktime",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "disable paste",
	group = init_group,
	pattern = "*",
	command = "if &paste | set nopaste | echo 'nopaste' | endif",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "update diff",
	group = init_group,
	pattern = "*",
	command = "if &l:diff | diffupdate | endif",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "go back to previous position of cursor if any",
	group = init_group,
	pattern = "*",
	callback = function()
		local prev_line = vim.api.nvim_buf_get_mark(0, '"')[1]

		if prev_line > 0 and prev_line <= vim.api.nvim_buf_line_count(0) then
			local go_to_prev_mark = 'g`"'
			local open_folds = "zv"
			local redraw_line = "zz"
			vim.cmd("normal!" .. go_to_prev_mark .. open_folds .. redraw_line)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "set showbreak",
	group = init_group,
	pattern = "*",
	callback = function()
		vim.wo.showbreak = "=>"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "disable showbreak for markdown files",
	group = init_group,
	pattern = { "markdown", "Avante" },
	callback = function()
		vim.wo.showbreak = ""
	end,
})

-- terminal autocommands
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "switch to insert mode and press up when in terminal normal mode",
	pattern = "*",
	command = "nnoremap <buffer> <up> i<up>",
})

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "switch to insert mode and press <c-r> when in terminal normal mode",
	pattern = "*",
	command = "nnoremap <buffer> <c-r> i<c-r>",
})

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "disable macros in terminals",
	pattern = "*",
	command = "nnoremap <buffer> q <nop>",
})

local function switch_source_header(bufnr, wait_ms)
	bufnr = bufnr or 0
	wait_ms = wait_ms or 5000

	local result = vim.lsp.buf_request_sync(
		bufnr,
		"textDocument/switchSourceHeader",
		vim.lsp.util.make_text_document_params(),
		wait_ms
	)
	for _, res in pairs(result or {}) do
		if res.result then
			vim.cmd("edit " .. res.result)
		end
	end
end

local mappings = {
	{
		"gD",
		vim.lsp.buf.declaration,
		{ desc = "jump to the declaration of the symbol under the cursor" },
	},
	{
		"K",
		vim.lsp.buf.hover,
		{ desc = "show hover information for the symbol under the cursor in a floating window" },
	},
	{
		"<leader>k",
		vim.lsp.buf.signature_help,
		{ desc = "show signature help for the symbol under the cursor in a floating window" },
	},
	{
		"<leader>wa",
		vim.lsp.buf.add_workspace_folder,
		{ desc = "add the current file's directory to the workspace folders" },
	},
	{
		"<leader>wr",
		vim.lsp.buf.remove_workspace_folder,
		{ desc = "remove the current file's directory from the workspace folders" },
	},
	{
		"<leader>wl",
		function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end,
		{ desc = "list the workspace folders" },
	},
	{
		"<leader>ca",
		vim.lsp.buf.code_action,
		{ desc = "selects a code action available at the current cursor position" },
	},
	{
		"<leader>e",
		vim.diagnostic.open_float,
		{ desc = "show diagnostics in a floating window" },
	},
	{
		"[d",
		vim.diagnostic.goto_prev,
		{ desc = "move to the previous diagnostic in the current buffer" },
	},
	{
		"]d",
		vim.diagnostic.goto_next,
		{ desc = "move to the next diagnostic" },
	},
	{
		"<leader>cl",
		vim.lsp.codelens.run,
		{ desc = "run the code lens in the current line" },
	},
	{
		"<leader>d",
		function()
			vim.diagnostic.enable(not vim.diagnostic.is_enabled())
		end,
		{ desc = "enables or disables diagnostics" },
	},
}

local on_attach = function(ev)
	local bufnr = ev.buf
	local client = vim.lsp.get_client_by_id(ev.data.client_id)

	safe_require("lsp_signature", function(lsp_signature)
		lsp_signature.on_attach(nil, bufnr)
	end)

	safe_require("rubix/format", function(format)
		format.on_attach(client, bufnr)
	end)

	if
		client
		and client.server_capabilities.codeLensProvider ~= nil
		and client.server_capabilities.codeLensProvider ~= false
	then
		vim.api.nvim_create_autocmd({
			"CursorHold",
			"CursorHoldI",
			"InsertLeave",
		}, {
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.refresh({ bufnr = bufnr })
			end,
		})
	end

	for _, mapping in ipairs(mappings) do
		local opts = mapping[3] or {}
		opts.buffer = bufnr
		vim.keymap.set("n", mapping[1], mapping[2], opts)
	end

	if client and client.supports_method("textDocument/switchSourceHeader") then
		vim.keymap.set("n", "<leader>cs", switch_source_header, { buffer = bufnr })
	end
end

-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "lsp on_attach",
	callback = on_attach,
	group = init_group,
})
