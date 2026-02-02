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
				-- Exclude compound template files (.*.gotmpl) from golangci-lint
				golangcilint = {
					condition = function(ctx)
						return not vim.endswith(ctx.filename, ".gotmpl")
					end,
				},
				sqlfluff = {
					args = { "lint", "--format=json" },
				},
				buf_lint = function()
					local buf = vim.api.nvim_get_current_buf()
					-- Add buf-specific root markers to root_spec
					---@diagnostic disable-next-line: param-type-mismatch
					local first = type(vim.g.root_spec[1]) == "table" and vim.deepcopy(vim.g.root_spec[1]) or {}
					---@cast first table
					vim.list_extend(first, { "buf.yaml", "buf.work.yaml" })
					local spec = { first, unpack(vim.g.root_spec, 2) }
					local roots = LazyVim.root.detect({ spec = spec, buf = buf })
					local cwd = roots[1] and roots[1].paths[1] or vim.uv.cwd()

					-- buf expects: buf lint <input> where input is the directory to lint
					-- We pass "." to lint from the cwd (repo root) with --path to limit to current file
					return vim.tbl_deep_extend("force", require("lint.linters.buf_lint"), {
						cwd = cwd,
						args = { "lint", ".", "--error-format", "json", "--path" },
						append_fname = true,
					})
				end,
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
