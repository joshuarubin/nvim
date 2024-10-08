return {
	{
		"pmizio/typescript-tools.nvim",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		opts = function()
			return {
				on_attach = function(client, bufnr)
					-- disable tsserver formatting (done by null-ls)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				handlers = {
					["textDocument/publishDiagnostics"] = require("typescript-tools.api").filter_diagnostics({
						6133,
						6196,
					}),
				},
				settings = {
					publish_diagnostic_on = "insert_leave",
					expose_as_code_action = {},
					tsserver_file_preferences = {},
					complete_function_calls = false,
					include_completions_with_insert_text = true,
				},
			}
		end,
	},
}
