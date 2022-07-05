require("plugins")

if vim.env.GROQ_CONFIG then
	vim.cmd("source " .. vim.env.GROQ_CONFIG .. "/vim/groq.vim")
end

local function backupdir()
	local ret = vim.fn.stdpath("data") .. "/backup"
	if vim.fn.isdirectory(ret) ~= 1 then
		vim.fn.mkdir(ret, "p", "0700")
	end
	return ret
end

vim.o.shada = "!,'1000,<50,s10,h"
vim.o.dictionary = "/usr/share/dict/words"
vim.o.undofile = true -- persistent undo
vim.o.backup = true
vim.o.backupcopy = "yes"
vim.o.backupdir = backupdir()
vim.o.synmaxcol = 512
vim.o.list = true
vim.o.listchars = "tab:│ ,trail:•,precedes:❮,nbsp:.,conceal:Δ"
vim.o.fillchars = "vert:│,fold:-"
vim.o.foldcolumn = "auto:9"
vim.o.title = true
vim.o.linebreak = true -- wrap lines at convenient points
vim.o.showbreak = "=>"
vim.o.whichwrap = "b,s,<,>,[,]"
vim.o.breakindent = true
vim.o.shortmess = "filnxtToOFcI"
vim.o.wildmode = "longest,full"
vim.o.wildignorecase = true
vim.o.wildignore = "*.o,*.obj,*~,*.so,*.swp,*.DS_Store" -- stuff to ignore when tab completing
vim.o.showfulltag = true
vim.o.completeopt = "noinsert,menuone,noselect"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.diffopt = "internal,filler,closeoff,vertical,foldcolumn:0"
vim.o.winheight = 10
vim.o.lazyredraw = true
vim.o.conceallevel = 2
vim.o.concealcursor = "n"
vim.o.showmode = false
vim.o.showtabline = 2 -- prevent flicker, lualine shows info anyway
vim.o.showcmd = false
vim.o.number = true -- line numbers are good
vim.o.scrolloff = 8 -- start scrolling when we're 8 lines away from margins
vim.o.sidescrolloff = 15
vim.o.scrolljump = 3
vim.o.numberwidth = 1
vim.o.cursorline = true
vim.o.signcolumn = "number"
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.clipboard = "unnamedplus,unnamed" -- use clipboard register
vim.o.matchpairs = "(:),{:},[:],<:>"
vim.o.hidden = true -- hide buffers when they are abandoned
vim.o.infercase = true -- ignore case on insert completion
vim.o.grepprg = "rg --with-filename --no-heading --line-number --column --hidden --smart-case --follow"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.timeoutlen = 2000
vim.o.ttimeoutlen = 10
vim.o.updatetime = 250
vim.o.virtualedit = "block"
vim.o.formatoptions = "jcroqlt"
vim.o.textwidth = 80
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.joinspaces = false
vim.o.smartindent = true
vim.o.ignorecase = true -- case insensitive matching
vim.o.smartcase = true -- smart case matching
vim.o.tags = "./tags;/,~/.vimtags"
vim.o.mouse = "nv"
vim.o.spell = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.o.guifont = "JetBrainsMono Nerd Font Rubix:h12"

vim.opt.isfname:remove({ "=" })

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.vim_json_conceal = 0

local function t(keys)
	return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

vim.g.neovide_input_use_logo = 1

-- colorscheme
vim.o.termguicolors = true
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", command = "highlight Comment gui=italic cterm=italic" })
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", command = "highlight link HlSearchLens Comment" })
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", command = "highlight link HlSearchLensNear Comment" })

vim.env.GIT_SSH_COMMAND = "ssh -o ControlPersist=no"

vim.keymap.set("n", "<leader>g.", function()
	vim.cmd("lcd " .. vim.fn.expand("%:p:h"))
	local dir = vim.fn.system("git rev-parse --git-dir"):gsub(".git", "")
	dir = vim.trim(dir)
	if dir ~= "" then
		dir = vim.fn.fnamemodify(dir, ":p")
		vim.cmd("lcd " .. dir)
	end
end)

local function safe_require(modules, callback)
	if type(modules) == "string" then
		modules = { modules }
	end

	local mods = {}

	for _, module in ipairs(modules) do
		local ok, mod = pcall(require, module)
		if not ok then
			return
		end

		table.insert(mods, mod)
	end

	callback(unpack(mods))
end

safe_require("nvim-lsp-installer", function(nvim_lsp_installer)
	-- NOTE: must be called before any servers are set up
	nvim_lsp_installer.setup({
		automatic_installation = {
			exclude = { "hls" },
		},
	})
end)

local function switch_source_header(bufnr, wait_ms)
	bufnr = bufnr or 0
	wait_ms = wait_ms or 5000

	local result = vim.lsp.buf_request_sync(
		bufnr,
		"textDocument/switchSourceHeader",
		vim.lsp.util.make_text_document_params(),
		wait_ms
	)
	for _, res in pairs(result or {}) do
		if res.result then
			vim.cmd("edit " .. res.result)
		end
	end
end

local function lsp_supports_method(method, bufnr)
	bufnr = bufnr or 0
	for _, client in pairs(vim.lsp.buf_get_clients(bufnr)) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

-- if there's only one code action available, just execute it, otherwise, show
-- the menu
local function code_action(context)
	context = context or {}
	local bufnr = vim.api.nvim_get_current_buf()
	local params = vim.lsp.util.make_range_params()
	params.context = {
		diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr),
	}

	local method = "textDocument/codeAction"

	if not lsp_supports_method(method, bufnr) then
		return
	end

	local num = {}
	vim.lsp.buf_request_all(bufnr, method, params, function(results)
		for _, res in pairs(results or {}) do
			for _, r in pairs(res.result or {}) do
				table.insert(num, r)
			end
		end
		if #num == 1 then
			if num[1].edit then
				vim.lsp.util.apply_workspace_edit(num[1].edit, "utf-8")
			else
				vim.lsp.buf.execute_command(num[1].command)
			end
		else
			vim.lsp.buf.code_action()
		end
	end)
end

local function organize_imports(bufnr, wait_ms)
	local method = "textDocument/codeAction"

	if not lsp_supports_method(method, bufnr) then
		return
	end

	local params = vim.lsp.util.make_range_params()
	params.context = {
		only = { "source.organizeImports" },
		diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr),
	}
	local result = vim.lsp.buf_request_sync(bufnr, method, params, wait_ms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.kind == "source.organizeImports" then
				if r.edit then
					vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
				else
					vim.lsp.buf.execute_command(r.command)
				end
			end
		end
	end
end

local function lsp_format(opts)
	opts = opts or { buf = 0 }

	if vim.b.autoformat ~= 1 then
		return
	end

	organize_imports(opts.buf, 5000)

	vim.lsp.buf.formatting_sync(nil, 5000)
end

local lsp_formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})
local function on_attach(client, bufnr)
	safe_require("aerial", function(aerial)
		aerial.on_attach(client, bufnr)
	end)

	safe_require("lsp_signature", function(lsp_signature)
		lsp_signature.on_attach(nil, bufnr)
	end)

	if vim.b.autoformat == nil then
		vim.b.autoformat = 1
	end

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({
			group = lsp_formatting_group,
			buffer = bufnr,
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = lsp_formatting_group,
			buffer = bufnr,
			callback = lsp_format,
		})
	end

	vim.api.nvim_create_autocmd({
		"CursorHold",
		"CursorHoldI",
		"InsertLeave",
	}, {
		buffer = bufnr,
		callback = function()
			if client.server_capabilities.codeLensProvider ~= nil then
				vim.lsp.codelens.refresh()
			end
		end,
	})

	vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>", { buffer = bufnr, silent = true })
	vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { buffer = bufnr, silent = true })
	vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { buffer = bufnr, silent = true })
	vim.keymap.set("n", "{", "<cmd>AerialPrevUp<CR>", { buffer = bufnr, silent = true })
	vim.keymap.set("n", "}", "<cmd>AerialNextUp<CR>", { buffer = bufnr, silent = true })

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
	vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = bufnr })
	vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr })
	vim.keymap.set("n", "<leader>ca", code_action, { buffer = bufnr })
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = bufnr })
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })
	vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = bufnr })

	safe_require("telescope.builtin", function(telescope_builtin)
		vim.keymap.set("n", "<leader>so", telescope_builtin.lsp_document_symbols, { buffer = bufnr })
	end)

	if client.supports_method("textDocument/switchSourceHeader") then
		vim.keymap.set("n", "<leader>cs", switch_source_header, { buffer = bufnr })
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

safe_require("cmp_nvim_lsp", function(cmp_nvim_lsp)
	capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end)

safe_require("lspconfig", function(nvim_lsp)
	local servers = { "bashls", "cmake", "dockerls", "hls", "pyright", "vimls", "zls" }
	for _, lsp in ipairs(servers) do
		nvim_lsp[lsp].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end

	local clangd_capabilities = vim.deepcopy(capabilities)
	-- required to get rid of a warning about multiple different offset encodings
	clangd_capabilities.offsetEncoding = { "utf-16" }
	clangd_capabilities.textDocument.publishDiagnostics.categorySupport = true
	clangd_capabilities.textDocument.publishDiagnostics.codeActionsInline = true
	nvim_lsp.clangd.setup({
		on_attach = on_attach,
		capabilities = clangd_capabilities,
	})

	nvim_lsp.gopls.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			gopls = {
				buildFlags = { "-tags=wireinject" },
				usePlaceholders = true,
				codelenses = {
					gc_details = true,
					generate = true,
					nilness = true,
					regenerate_cgo = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
				analyses = {
					nilness = true,
					shadow = true,
					unusedparams = true,
					unusedwrite = true,
				},
				gofumpt = true,
				staticcheck = true,
				expandWorkspaceToModule = true,
			},
		},
		flags = {
			debounce_text_changes = 200,
		},
	})

	-- javascript, typescript, react and tsx
	safe_require("nvim-lsp-ts-utils", function(ts_utils)
		nvim_lsp.tsserver.setup({
			init_options = ts_utils.init_options,
			on_attach = function(client, bufnr)
				-- disable tsserver formatting (done by null-ls)
				client.resolved_capabilities.document_formatting = false
				client.resolved_capabilities.document_range_formatting = false

				ts_utils.setup({})
				ts_utils.setup_client(client)

				on_attach(client, bufnr)
			end,
			capabilities = capabilities,
		})
	end)

	local lua_path = vim.split(package.path, ";")
	table.insert(lua_path, "lua/?.lua")
	table.insert(lua_path, "lua/?/init.lua")

	nvim_lsp.sumneko_lua.setup({
		on_attach = function(client, bufnr)
			-- disable sumneko formatting (done by null-ls.stylua)
			client.resolved_capabilities.document_formatting = false
			client.resolved_capabilities.document_range_formatting = false

			on_attach(client, bufnr)
		end,
		capabilities = capabilities,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = lua_path,
				},
				diagnostics = {
					globals = { "vim", "hs" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})
end)

safe_require("rust-tools", function(rust_tools)
	rust_tools.setup({
		server = {
			on_attach = on_attach,
			capabilities = capabilities,
		},
	})
end)

safe_require("null-ls", function(null_ls)
	null_ls.setup({
		on_attach = on_attach,
		sources = {
			null_ls.builtins.code_actions.eslint.with({ prefer_local = "node_modules/.bin" }), -- javascript, typescript, react and tsx
			null_ls.builtins.code_actions.shellcheck, -- sh
			null_ls.builtins.code_actions.statix, -- nix
			null_ls.builtins.diagnostics.buf.with({ args = { "lint", "--path", "$DIRNAME" } }), -- proto
			null_ls.builtins.diagnostics.deadnix, -- nix
			null_ls.builtins.diagnostics.eslint.with({ prefer_local = "node_modules/.bin" }), -- javascript, typescript, react and tsx,
			null_ls.builtins.diagnostics.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }), -- sql
			null_ls.builtins.diagnostics.statix, -- nix
			null_ls.builtins.diagnostics.teal, -- teal
			null_ls.builtins.diagnostics.vale, -- markdown, tex, asciidoc
			null_ls.builtins.formatting.alejandra, -- nix
			null_ls.builtins.formatting.buf, -- proto
			null_ls.builtins.formatting.prettier.with({ prefer_local = "node_modules/.bin" }), -- javascript, typescript, react, vue, css, scss, less, html, json, yaml, markdown, graphql, handlebars
			null_ls.builtins.formatting.shfmt.with({ args = {} }), -- sh
			null_ls.builtins.formatting.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }), -- javascript, typescript, react and tsx
			null_ls.builtins.formatting.stylua, -- lua
			null_ls.builtins.hover.dictionary, -- text, markdown
		},
	})
end)

vim.cmd([[sign define DiagnosticSignError text= texthl=LspDiagnosticsSignError       linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn  text= texthl=LspDiagnosticsSignWarning     linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo  text= texthl=LspDiagnosticsSignInformation linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint  text= texthl=LspDiagnosticsSignHint        linehl= numhl=]])

safe_require({ "luasnip", "cmp" }, function(luasnip, cmp)
	require("luasnip/loaders/from_vscode").lazy_load()

	cmp.setup({
		preselect = require("cmp.types").cmp.PreselectMode.None,
		sources = {
			{ name = "buffer" },
			{ name = "calc" },
			{ name = "emoji" },
			{ name = "luasnip" },
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "path" },
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = {
			["<c-p>"] = cmp.mapping.select_prev_item(),
			["<c-n>"] = cmp.mapping.select_next_item(),
			["<c-d>"] = cmp.mapping.scroll_docs(-4),
			["<c-f>"] = cmp.mapping.scroll_docs(4),
			["<c-space>"] = cmp.mapping.complete({}),
			["<c-e>"] = cmp.mapping(function(fallback)
				fallback()
			end),
			["<cr>"] = cmp.mapping(function(fallback)
				local expandable = luasnip.expandable()

				-- if the popup menu is visible
				if cmp.visible() then
					local selected = cmp.core.view:get_selected_entry()

					if selected then -- normal completion
						cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace })(fallback)
					elseif expandable then -- nothing is selected in the popup menu, but the entered text is an expandable snippet
						vim.fn.feedkeys(t("<plug>luasnip-expand-snippet"))
					else
						cmp.abort() -- close cmp
						vim.fn.feedkeys(t("<c-]>")) -- complete abbreviations

						-- fallback to normal <cr>
						vim.fn.feedkeys(t("<cr>"), "n") -- using fallback() breaks abbreviations
					end
				elseif expandable then -- there's no popup, but the entered text is an expandable snippet
					vim.fn.feedkeys(t("<plug>luasnip-expand-snippet"))
				else
					vim.fn.feedkeys(t("<c-]>")) -- complete abbreviations
					vim.fn.feedkeys(t("<c-g>u")) -- create undo point

					-- fallback to normal <cr>
					vim.fn.feedkeys(t("<cr>"), "n") -- using fallback() breaks abbreviations

					-- telescope breaks when opening a new file in the same buffer unless we do this
					local filetype = vim.api.nvim_buf_get_option(0, "filetype")
					if filetype ~= "TelescopePrompt" then
						vim.fn.feedkeys(t("<plug>Endwise"))
					end
				end
			end, {
				"i",
			}),
			["<tab>"] = cmp.mapping(function(fallback)
				if vim.fn.pumvisible() == 1 then
					vim.fn.feedkeys(t("<c-n>"), "n")
				elseif cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
			["<s-tab>"] = cmp.mapping(function(fallback)
				if vim.fn.pumvisible() == 1 then
					vim.fn.feedkeys(t("<c-p>"), "n")
				elseif cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
		},
		formatting = {
			format = function(_, vim_item)
				local icons = {
					Class = "",
					Color = "",
					Constant = "",
					Constructor = "",
					Enum = "",
					EnumMember = "",
					Event = "",
					Field = "ﰠ",
					File = "",
					Folder = "",
					Function = "",
					Interface = "ﰮ",
					Keyword = "",
					Method = "",
					Module = "",
					Operator = "",
					Property = "ﰠ",
					Reference = "",
					Snippet = "﬌",
					Struct = "",
					Text = "",
					TypeParameter = "",
					Unit = "塞",
					Value = "",
					Variable = "",
				}
				if icons[vim_item.kind] ~= nil then
					vim_item.kind = icons[vim_item.kind] .. " " .. vim_item.kind
				end
				return vim_item
			end,
		},
	})
end)

-- paste
for _, lhs in ipairs({ "<c-v>", "<d-v>" }) do
	vim.keymap.set({ "n", "x" }, lhs, '"+p', { remap = true })
	vim.keymap.set("i", lhs, "<c-r>+", { remap = true })
	vim.keymap.set("t", lhs, '<c-\\><c-n>"+pa', { remap = true })
	vim.keymap.set("c", lhs, "<c-r>+")
end

-- undo
vim.keymap.set("n", "<d-z>", "<undo>")
vim.keymap.set("i", "<d-z>", function()
	vim.cmd(t("normal <undo>"))
	vim.api.nvim_feedkeys(t("<right>"), "n", false)
end)

-- resize
vim.keymap.set({ "n", "v" }, "<c-a>H", "<c-w><")
vim.keymap.set({ "n", "v" }, "<c-a>J", "<c-w>+")
vim.keymap.set({ "n", "v" }, "<c-a>K", "<c-w>-")
vim.keymap.set({ "n", "v" }, "<c-a>L", "<c-w>>")

vim.keymap.set({ "n", "v" }, "<d-h>", "<c-w><")
vim.keymap.set({ "n", "v" }, "<d-j>", "<c-w>+")
vim.keymap.set({ "n", "v" }, "<d-k>", "<c-w>-")
vim.keymap.set({ "n", "v" }, "<d-l>", "<c-w>>")

vim.keymap.set("i", "<c-a>H", '<c-r>=execute("normal! \\<lt>c-w><")<cr>', { silent = true })
vim.keymap.set("i", "<c-a>J", '<c-r>=execute("normal! \\<lt>c-w>+")<cr>', { silent = true })
vim.keymap.set("i", "<c-a>K", '<c-r>=execute("normal! \\<lt>c-w>-")<cr>', { silent = true })
vim.keymap.set("i", "<c-a>L", '<c-r>=execute("normal! \\<lt>c-w>>")<cr>', { silent = true })

vim.keymap.set("i", "<d-h>", '<c-r>=execute("normal! \\<lt>c-w><")<cr>', { silent = true })
vim.keymap.set("i", "<d-j>", '<c-r>=execute("normal! \\<lt>c-w>+")<cr>', { silent = true })
vim.keymap.set("i", "<d-k>", '<c-r>=execute("normal! \\<lt>c-w>-")<cr>', { silent = true })
vim.keymap.set("i", "<d-l>", '<c-r>=execute("normal! \\<lt>c-w>>")<cr>', { silent = true })

vim.keymap.set("t", "<c-a>H", "<c-\\><c-n><c-w><i")
vim.keymap.set("t", "<c-a>J", "<c-\\><c-n><c-w>+i")
vim.keymap.set("t", "<c-a>K", "<c-\\><c-n><c-w>-i")
vim.keymap.set("t", "<c-a>L", "<c-\\><c-n><c-w>>i")

vim.keymap.set("t", "<d-h>", "<c-\\><c-n><c-w><i")
vim.keymap.set("t", "<d-j>", "<c-\\><c-n><c-w>+i")
vim.keymap.set("t", "<d-k>", "<c-\\><c-n><c-w>-i")
vim.keymap.set("t", "<d-l>", "<c-\\><c-n><c-w>>i")

-- normal mode
vim.keymap.set("n", "<leader>n", ":nohlsearch<cr>", { silent = true })
vim.keymap.set("n", "<leader>fc", "/\\v^[<|=>]{7}( .*|$)<cr>") -- find merge conflict markers
vim.keymap.set("n", "<leader>q", ":qa<cr>", { silent = true })
vim.keymap.set("n", "<leader>Q", ":qa!<cr>", { silent = true })
vim.keymap.set("n", "<leader>cd", ":lcd %:p:h<cr>:pwd<cr>") -- switch to the directory of the open buffer
vim.keymap.set("n", "<leader>=", "<c-w>=") -- adjust viewports to the same size
vim.keymap.set("n", "Q", ":q<cr>", { silent = true }) -- Q: Closes the window
vim.keymap.set("n", "W", ":w<cr>", { silent = true }) -- W: Save
vim.keymap.set("n", "_", ":sp<cr>", { silent = true }) -- _: Quick horizontal splits
vim.keymap.set("n", "<bar>", ":vsp<cr>", { silent = true }) -- |: Quick vertical splits
vim.keymap.set("n", "+", "<c-a>") -- +: Increment number
vim.keymap.set("n", "=", "<c-a>") -- =: Increment number
vim.keymap.set("n", "-", "<c-x>") -- -: Decrement number
vim.keymap.set("n", "d", '"_d') -- d: Delete into the blackhole register to not clobber the last yank
vim.keymap.set("n", "dd", "dd") -- dd: I use this often to yank a single line, retain its original behavior
vim.keymap.set("n", "c", '"_c') -- c: Change into the blackhole register to not clobber the last yank
vim.keymap.set("n", "<c-a>r", ":redraw!<cr>", { silent = true }) -- ctrl-a r to redraw the screen now

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, ":" .. i .. "wincmd w<cr>", { silent = true }) -- <leader>[1-9]  move to window [1-9]
	vim.keymap.set("n", "<leader>b" .. i, ":b" .. i .. "<cr>", { silent = true }) -- <leader>b[1-9] move to buffer [1-9]
end

-- visual mode
vim.keymap.set("x", "y", "y`]") -- y: Yank and go to end of selection
vim.keymap.set("x", "p", '"_dP') -- p: Paste in visual mode should not replace the default register with the deleted text
vim.keymap.set("x", "d", '"_d') -- d: Delete into the blackhole register to not clobber the last yank. To 'cut', use 'x' instead
vim.keymap.set("x", "<cr>", 'y:let @/ = @"<cr>:set hlsearch<cr>', { silent = true }) -- enter: Highlight visual selections
vim.keymap.set("x", "<", "<gv") -- <: Retain visual selection after indent
vim.keymap.set("x", ">", ">gv") -- >: Retain visual selection after indent
vim.keymap.set("x", ".", ":normal.<cr>", { silent = true }) -- .: repeats the last command on every line
vim.keymap.set("x", "@", ":normal@@<cr>", { silent = true }) -- @: repeats the last macro on every line
vim.keymap.set("x", "<tab>", ">", { remap = true }) -- tab: Indent (allow recursive)
vim.keymap.set("x", "<s-tab>", "<", { remap = true }) -- shift-tab: unindent (allow recursive)

-- visual and select mode
vim.keymap.set("v", "<leader>s", ":sort<cr>")

-- command line mode
vim.keymap.set("c", "<c-j>", "<down>")
vim.keymap.set("c", "<c-k>", "<up>")
vim.keymap.set("c", "<cr>", function()
	if vim.fn.wildmenumode() == 1 then
		vim.fn.feedkeys(t("<c-y>"))
		if not vim.fn.getcmdline():match("/$") then
			vim.fn.feedkeys(t("<cr>"))
		end
		return ""
	end
	return "<cr>"
end, { expr = true })

-- insert mode
vim.keymap.set("i", "<c-w>", "<c-g>u<c-w>") -- ctrl-w: Delete previous word, create undo point

-- terminal mode
vim.keymap.set("t", "<c-y>", "<c-\\><c-n><c-y>") -- scroll up one line
vim.keymap.set("t", "<c-u>", "<c-\\><c-n><c-u>") -- scroll up half a screen

-- abbreviations
vim.cmd([[iabbrev TODO TODO(jawa)]])
vim.cmd([[iabbrev meml me@jawa.dev]])

-- autocommands
local init_group = vim.api.nvim_create_augroup("InitAutoCmd", {})

vim.api.nvim_create_autocmd("InsertEnter", {
	desc = "disable search highlighting in insert mode",
	group = init_group,
	pattern = "*",
	command = "setlocal nohlsearch",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "enable search highlighting when leaving insert mode",
	group = init_group,
	pattern = "*",
	command = "setlocal hlsearch",
})

vim.api.nvim_create_autocmd("WinEnter", {
	desc = "check timestamp more for 'autoread'",
	group = init_group,
	pattern = "*",
	command = "checktime",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "disable paste",
	group = init_group,
	pattern = "*",
	command = "if &paste | set nopaste | echo 'nopaste' | endif",
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "update diff",
	group = init_group,
	pattern = "*",
	command = "if &l:diff | diffupdate | endif",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "go back to previous position of cursor if any",
	group = init_group,
	pattern = "*",
	callback = function()
		local prev_line = vim.api.nvim_buf_get_mark(0, '"')[1]

		if prev_line > 0 and prev_line <= vim.api.nvim_buf_line_count(0) then
			local go_to_prev_mark = 'g`"'
			local open_folds = "zv"
			local redraw_line = "zz"
			vim.cmd("normal!" .. go_to_prev_mark .. open_folds .. redraw_line)
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight on yank",
	group = init_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "set nospell for certain file types",
	group = init_group,
	pattern = { "aerial", "man" },
	command = "set nospell",
})

-- terminal autocommands
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "switch to insert mode and press up when in terminal normal mode",
	pattern = "*",
	command = "nnoremap <buffer> <up> i<up>",
})

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "switch to insert mode and press <c-r> when in terminal normal mode",
	pattern = "*",
	command = "nnoremap <buffer> <c-r> i<c-r>",
})

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "disable macros in terminals",
	pattern = "*",
	command = "nnoremap <buffer> q <nop>",
})

vim.api.nvim_create_user_command("ToggleAutoFormat", function()
	if vim.b.autoformat ~= 1 then
		vim.b.autoformat = 1
	else
		vim.b.autoformat = 0
	end
end, {})

-- these two lines must be last
vim.o.exrc = true -- enable per-directory .vimrc files
vim.o.secure = true -- disable unsafe commands in local .vimrc files
