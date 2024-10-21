return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				fish = { "fish" },
				proto = { "buf_lint" },
				nix = { "deadnix", "statix" },
				sql = { "sqlfluff" },
				yaml = { "yamllint" },
			},
		},
	},
}
