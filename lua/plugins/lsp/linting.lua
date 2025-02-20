return {
	{
		"mfussenegger/nvim-lint",
		cond = not vim.g.vscode,
		init = function()
			local lint = require("lint")
			lint.linters.tofu_validate = function()
				local conf = lint.linters.terraform_validate()
				conf.cmd = "tofu"
				return conf
			end
		end,
		opts = {
			linters = {
				sqlfluff = {
					args = { "lint", "--format=json" },
				},
			},
			linters_by_ft = {
				fish = { "fish" },
				nix = { "deadnix", "statix" },
				proto = { "buf_lint" },
				sql = { "sqlfluff" },
				terraform = { "tofu_validate" },
				tf = { "tofu_validate" },
				yaml = { "yamllint" },
			},
		},
	},
}
