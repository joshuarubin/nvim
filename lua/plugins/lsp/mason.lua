return {
	{
		"williamboman/mason.nvim",
		cond = not vim.g.vscode,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		cond = not vim.g.vscode,
		config = function(_, opts)
			local mason = require("mason")
			local mason_registry = require("mason-registry")
			local mason_lspconfig = require("mason-lspconfig")

			mason.setup(opts)

			mason_lspconfig.setup({
				automatic_installation = {
					exclude = {
						"clangd",
						"rust-analyzer",
						"zls",
					},
				},
			})

			local ensure_installed = {
				"yamllint",
			}

			for _, pkg in ipairs(ensure_installed) do
				if not mason_registry.is_installed(pkg) then
					mason_registry.get_package(pkg):install()
				end
			end
		end,
	},
}
