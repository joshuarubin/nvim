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
	},
}
