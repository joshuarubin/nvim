return {
	{
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			-- disable these mappings
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] = { "[[", false }
			keys[#keys + 1] = { "]]", false }

			-- remove the { reuse_win = true } option from these keymaps
			keys[#keys + 1] = {
				"gd",
				function()
					require("telescope.builtin").lsp_definitions()
				end,
				desc = "Goto Definition",
				has = "definition",
			}
			keys[#keys + 1] = {
				"gI",
				function()
					require("telescope.builtin").lsp_implementations()
				end,
				desc = "Goto Implementation",
			}
			keys[#keys + 1] = {
				"gy",
				function()
					require("telescope.builtin").lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			}

			-- change the default config a bit
			opts.codelens.enabled = true

			-- enable a few more servers
			opts.servers.jsonnet_ls = {}
			opts.servers.vimls = {}
			opts.servers.zls = {}

			return opts
		end,
	},
}
