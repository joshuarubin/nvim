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
			opts.formatters.goimports = {
				append_args = { "-local=" .. table.concat(local_imports, ",") },
			}

			return opts
		end,
	},
	{
		"nvim-neotest/neotest",
		opts = {
			adapters = {
				["neotest-golang"] = {
					go_test_args = { "-race" },
					dap_go_enabled = true,
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			opts.servers.gopls.settings.gopls.analyses.fieldalignment = false
			opts.servers.gopls.settings.gopls.analyses.shadow = true
			opts.servers.gopls.settings.gopls.analyses.unusedvariable = true
			opts.servers.gopls.settings.gopls.analyses.ST1000 = false
			opts.servers.gopls.settings.gopls.codelenses.gc_details = true
			opts.servers.gopls.settings.gopls.buildFlags = { "-tags=wireinject,integration" }
			opts.servers.gopls.settings.gopls["local"] = table.concat(local_imports, ",")
			opts.servers.gopls.settings.gopls.gofumpt = true
			opts.servers.gopls.settings.gopls.vulncheck = "Imports"

			-- Filter out unwanted diagnostics
			opts.servers.gopls.handlers = {
				["textDocument/publishDiagnostics"] = function(err, result, ctx)
					if result and result.diagnostics then
						result.diagnostics = vim.tbl_filter(function(diag)
							-- Filter out shadow warnings for "err" variable
							if diag.message and diag.message:match("shadow") and diag.message:match('"err"') then
								return false
							end

							-- Filter out ST1000 package comment requirement
							if diag.code == "ST1000" or (diag.message and diag.message:match("ST1000")) then
								return false
							end
							return true
						end, result.diagnostics)
					end
					vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
				end,
			}

			-- Extend default keys instead of replacing them
			opts.servers.gopls.keys = vim.list_extend(opts.servers.gopls.keys or {}, {
				{
					"<leader>co",
					LazyVim.lsp.action["source.organizeImports"],
					desc = "Organize Imports",
				},
			})
		end,
		init = function()
			local function get_client(buf)
				return vim.lsp.get_clients({ name = "gopls", bufnr = buf })[1]
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

					local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
					---@diagnostic disable-next-line: inject-field
					params.context = context

					---@diagnostic disable-next-line: param-type-mismatch
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
