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
			-- Add border to hover window
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			---@diagnostic disable-next-line: duplicate-set-field
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
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
