local lsp_util = require("util.lsp")

local group = vim.api.nvim_create_augroup("LSPConfig", {})

-- Re-apply lazydev's root_dir wrapper after lua_ls start/restart
-- util/lsp.lua clears function-based root_dir before calling vim.lsp.start(),
-- so we need to restore lazydev's workspace detection for proper .luarc.json discovery
vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = { "LspStartPost", "LspRestartPost" },
	callback = lsp_util.on_client("lua_ls", function()
		local ok, lspconfig = pcall(require, "lazydev.integrations.lspconfig")
		if ok then
			lspconfig.setup()
		end
	end),
})

return {
	{
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			-- disable these mappings by extending the default keys
			opts.servers["*"].keys = vim.list_extend(opts.servers["*"].keys or {}, {
				{ "[[", false },
				{ "]]", false },
			})

			-- change the default config a bit
			opts.codelens.enabled = true
			opts.inlay_hints.enabled = false

			-- enable a few more servers
			opts.servers.jsonnet_ls = {}
			opts.servers.vimls = {}
			opts.servers.zls = {}

			return opts
		end,
		init = function()
			-- Add border to hover window and disable spell checking
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			---@diagnostic disable-next-line: duplicate-set-field
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
				-- Disable spell checking in the hover window
				if winnr then
					vim.api.nvim_set_option_value("spell", false, { win = winnr })
				end
				return bufnr, winnr
			end

			-- Configure diagnostics
			vim.diagnostic.config({
				severity_sort = true, -- show errors before warnings
				float = {
					border = "rounded",
					source = true,
				},
			})
		end,
	},
}
