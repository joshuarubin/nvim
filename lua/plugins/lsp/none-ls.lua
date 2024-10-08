return {
	{
		"nvimtools/none-ls.nvim",
		cond = not vim.g.vscode,
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					-- null_ls.builtins.code_actions.shellcheck, -- sh
					null_ls.builtins.code_actions.statix, -- nix
					null_ls.builtins.diagnostics.buf.with({ args = { "lint" } }),
					null_ls.builtins.diagnostics.deadnix, -- nix
					null_ls.builtins.diagnostics.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }), -- sql
					null_ls.builtins.diagnostics.statix, -- nix
					null_ls.builtins.diagnostics.teal, -- teal
					null_ls.builtins.diagnostics.yamllint, -- yaml
					null_ls.builtins.formatting.alejandra, -- nix
					null_ls.builtins.formatting.buf.with({ args = { "format", "-w", "--path", "$FILENAME" } }), -- proto
					null_ls.builtins.formatting.prettier.with({
						prefer_local = "node_modules/.bin",
						filetypes = {
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"vue",
							"css",
							"scss",
							"less",
							"html",
							"json",
							"jsonc",
							"yaml",
							"markdown",
							"markdown.mdx",
							"graphql",
							"handlebars",
						},
						extra_filetypes = {},
					}), -- javascript, typescript, react, vue, css, scss, less, html, json, yaml, markdown, graphql, handlebars
					null_ls.builtins.formatting.shfmt.with({ args = {} }), -- sh
					null_ls.builtins.formatting.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }), -- sql
					null_ls.builtins.formatting.stylua, -- lua
					null_ls.builtins.formatting.terraform_fmt,
					null_ls.builtins.hover.dictionary, -- text, markdown
				},
			})
		end,
	},
}
