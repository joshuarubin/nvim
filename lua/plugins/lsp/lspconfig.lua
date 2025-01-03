return {
	{
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			-- disable these mappings
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] = { "[[", false }
			keys[#keys + 1] = { "]]", false }

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
