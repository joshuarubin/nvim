return {
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft.luau = { "stylua" }
			opts.formatters_by_ft.markdown = { "markdown-toc", "prettier", "markdownlint-cli2" }
			opts.formatters_by_ft.nix = { "alejandra" }
			opts.formatters_by_ft.proto = { "buf" }
			opts.formatters_by_ft.terraform = { "tofu_fmt" }
			opts.formatters_by_ft.tf = { "tofu_fmt" }
			opts.formatters_by_ft["markdown.mdx"] = { "markdown-toc", "prettier", "markdownlint-cli2" }
			opts.formatters_by_ft["terraform-vars"] = { "tofu_fmt" }

			opts.formatters.injected.options.ignore_errors = false

			return opts
		end,
	},
}
