return {
	{
		"stevearc/conform.nvim",
		opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
				lsp_format = "fallback", -- not recommended to change
			},
			formatters_by_ft = {
				["markdown"] = { "markdown-toc", "prettier", "markdownlint-cli2" },
				["markdown.mdx"] = { "markdown-toc", "prettier", "markdownlint-cli2" },
				["terraform-vars"] = { "tofu_fmt" },
				fish = { "fish_indent" },
				go = { "goimports" },
				lua = { "stylua" },
				luau = { "stylua" },
				nix = { "alejandra" },
				proto = { "buf" },
				sh = { "shfmt" },
				sql = { "sqlfluff" },
				terraform = { "tofu_fmt" },
				tf = { "tofu_fmt" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
			},
		},
	},
}
