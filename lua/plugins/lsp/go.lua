local ms = require("vim.lsp.protocol").Methods

local local_imports = {
	"github.com/joshuarubin",
	"github.com/poolsideai",
}

local on_goimports_result = function(err, results, ctx)
	if err then
		vim.notify("Error running goimports: " .. err.message, vim.log.levels.ERROR)
		return
	end

	for _, r in pairs(results or {}) do
		if r.edit then
			local enc = (vim.lsp.get_client_by_id(ctx.client_id) or {}).offset_encoding or "utf-16"
			vim.lsp.util.apply_workspace_edit(r.edit, enc)
		end
	end
end

return {
	{
		"stevearc/conform.nvim",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			opts.formatters_by_ft.go = {} -- let everything be done by gopls

			opts.formatters.goimports = {
				append_args = { "-local=" .. table.concat(local_imports, ",") },
			}

			return opts
		end,
	},
	{
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			opts.servers.gopls.settings.gopls.analyses.fieldalignment = false
			opts.servers.gopls.settings.gopls.analyses.shadow = true
			opts.servers.gopls.settings.gopls.analyses.unusedvariable = true
			opts.servers.gopls.settings.gopls.codelenses.gc_details = true
			opts.servers.gopls.settings.gopls.buildFlags = { "-tags=wireinject" }
			opts.servers.gopls.settings.gopls["local"] = table.concat(local_imports, ",")
			opts.servers.gopls.settings.gopls.vulncheck = "Imports"

			opts.servers.gopls.keys = {
				{
					"<leader>co",
					LazyVim.lsp.action["source.organizeImports"],
					desc = "Organize Imports",
				},
			}
		end,
		init = function()
			local function get_client(buf)
				return LazyVim.lsp.get_clients({ name = "gopls", bufnr = buf })[1]
			end

			LazyVim.format.register(LazyVim.lsp.formatter({
				name = "goimports: lsp",
				primary = false, -- keep as false so that both standard gopls and this get enabled
				priority = 2,
				sources = function(buf)
					local client = get_client(buf)
					return client and { "gopls" } or {}
				end,
				format = function(buf)
					local client = get_client(buf)
					if not client then
						return
					end

					local context = {
						only = { "source.organizeImports" },
						diagnostics = {},
						triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
					}

					local params = vim.lsp.util.make_range_params()
					params.context = context

					local results = client.request_sync(ms.textDocument_codeAction, params, 1000, buf)
					if not results then
						return
					end

					on_goimports_result(results.err, results.result, {
						method = ms.textDocument_codeAction,
						client_id = client.id,
						bufnr = buf,
						params = params,
						version = 0,
					})
				end,
			}))
		end,
	},
}
