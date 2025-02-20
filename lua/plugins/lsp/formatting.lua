return {
	{
		"stevearc/conform.nvim",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			local util = require("conform.util")

			opts.formatters_by_ft.luau = { "stylua" }
			opts.formatters_by_ft.markdown = { "markdown-toc", "prettier", "markdownlint-cli2" }
			opts.formatters_by_ft.nix = { "alejandra" }
			opts.formatters_by_ft.proto = { "buf" }
			opts.formatters_by_ft.json = { "fixjson" }
			opts.formatters_by_ft.sql = { "sqlfluff" }
			opts.formatters_by_ft.terraform = { "tofu_fmt" }
			opts.formatters_by_ft.tf = { "tofu_fmt" }
			opts.formatters_by_ft["markdown.mdx"] = { "markdown-toc", "prettier", "markdownlint-cli2" }
			opts.formatters_by_ft["terraform-vars"] = { "tofu_fmt" }
			opts.formatters_by_ft.yaml = { lsp_format = "first" }

			opts.formatters.sqlfluff = {
				args = { "format", "-" },
			}
			opts.formatters.injected.options.ignore_errors = false

			return opts
		end,
	},
}
