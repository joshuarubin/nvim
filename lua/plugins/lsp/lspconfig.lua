local safe_require = require("funcs.safe_require")

local servers = {
	bashls = {},
	cmake = {},
	dockerls = {},
	hls = {},
	jsonnet_ls = {},
	pyright = {},
	terraformls = {},
	tflint = {},
	vimls = {},
	zls = {},
}

servers.clangd = {
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}

servers.gopls = {
	settings = {
		gopls = {
			buildFlags = { "-tags=wireinject" },
			usePlaceholders = true,
			codelenses = {
				gc_details = true,
				generate = true,
				nilness = true,
				regenerate_cgo = true,
				run_vulncheck_exp = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			analyses = {
				nilness = true,
				shadow = true,
				unusedparams = true,
				unusedvariable = true,
				unusedwrite = true,
				useany = true,
			},
			gofumpt = true,
			["local"] = "github.com/joshuarubin",
			staticcheck = true,
			vulncheck = "Imports",
		},
	},
	flags = {
		debounce_text_changes = 200,
	},
}

local lua_path = vim.split(package.path, ";")
table.insert(lua_path, "lua/?.lua")
table.insert(lua_path, "lua/?/init.lua")

servers.lua_ls = {
	on_attach = function(client, bufnr)
		-- disable sumneko formatting (done by null-ls.stylua)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = lua_path,
			},
			diagnostics = {
				globals = { "vim", "hs", "redis", "ARGV", "KEYS" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

-- this adds "capabilities" to the servers, it should be the last thing to
-- modify the server list
safe_require("cmp_nvim_lsp", function(cmp_nvim_lsp)
	local capabilities = cmp_nvim_lsp.default_capabilities()

	for lsp in pairs(servers) do
		servers[lsp].capabilities = capabilities
	end

	local clangd_capabilities = vim.deepcopy(capabilities)
	-- required to get rid of a warning about multiple different offset encodings
	clangd_capabilities.offsetEncoding = { "utf-16" }
	if clangd_capabilities.textDocument.publishDiagnostics then
		clangd_capabilities.textDocument.publishDiagnostics.categorySupport = true
		clangd_capabilities.textDocument.publishDiagnostics.codeActionsInline = true
	end

	servers.clangd.capabilities = clangd_capabilities
end)

return {
	{
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,
		config = function()
			local lspconfig = require("lspconfig")
			for server, config in pairs(servers) do
				lspconfig[server].setup(config)
			end
		end,
	},
}
