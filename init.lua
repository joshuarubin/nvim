-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

local use = require("packer").use
require("packer").startup(function()
	use("wbthomason/packer.nvim") -- package manager
	use("ton/vim-bufsurf") -- switch buffers based on viewing history per window
	use("tpope/vim-surround") -- quoting/parenthesizing made simple
	use("tpope/vim-repeat") -- enable repeating supported plugin maps with `.`
	use("tpope/vim-eunuch") -- helpers for unix
	use("tpope/vim-endwise") -- wisely add "end" in ruby, endfunction/endif/more in vim script, etc.
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("ludovicchabant/vim-gutentags") -- automatic tags management
	use("editorconfig/editorconfig-vim")
	use("kevinhwang91/nvim-hlslens")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })
	use({ "romgrk/nvim-treesitter-context", requires = "nvim-treesitter/nvim-treesitter" })

	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").opts)
		end,
	})

	-- lsp
	use("neovim/nvim-lspconfig")
	use("simrat39/rust-tools.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("jose-elias-alvarez/nvim-lsp-ts-utils")
	use("mhartington/formatter.nvim")

	-- completion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-calc")
	use("hrsh7th/cmp-emoji")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("saadparwaiz1/cmp_luasnip")

	-- snippets
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")

	-- telescope
	use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" } })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("jvgrootveld/telescope-zoxide")
	use("AckslD/nvim-neoclip.lua")

	use("tpope/vim-fugitive")
	use("folke/trouble.nvim")

	use("akinsho/toggleterm.nvim")
	use("joshuarubin/rubix.vim")
	use("joshuarubin/rubix-lightline.vim")
	use("joshuarubin/rubix-telescope.nvim")

	use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

	-- lightline
	use("itchyny/lightline.vim") -- a light and configurable statusline/tabline
	use("akinsho/bufferline.nvim")

	-- file type icons
	use("ryanoasis/vim-devicons")
	use("kyazdani42/nvim-web-devicons")

	-- colorscheme
	use("sainnhe/gruvbox-material")
	use("folke/lsp-colors.nvim")
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})
	use({ "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" })
end)

local backupdir = function()
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
vim.o.title = true
vim.o.linebreak = true -- wrap lines at convenient points
vim.o.showbreak = "=>"
vim.o.whichwrap = "b,s,<,>,[,]"
vim.o.breakindent = true
vim.o.shortmess = "filnxtToOFcI"
vim.o.wildmode = "list:longest,full"
vim.o.wildignorecase = true
vim.o.wildignore = "*.o,*.obj,*~,*.so,*.swp,*.DS_Store" -- stuff to ignore when tab completing
vim.o.showfulltag = true
vim.o.completeopt = "noinsert,menuone,noselect"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.diffopt = "internal,filler,closeoff,vertical"
vim.o.winheight = 10
vim.o.lazyredraw = true
vim.o.conceallevel = 2
vim.o.concealcursor = "niv"
vim.o.showmode = false
vim.o.showtabline = 2 -- prevent flicker, lightline shows info anyway
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
vim.o.updatetime = 300
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

vim.opt.isfname:remove({ "=" })

vim.g.mapleader = ","

local t = function(keys)
	return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

local nmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.api.nvim_set_keymap("n", lhs, rhs, opts)
end

local nnoremap = function(lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = true
	return nmap(lhs, rhs, opts)
end

local imap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.api.nvim_set_keymap("i", lhs, rhs, opts)
end

local inoremap = function(lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = true
	return imap(lhs, rhs, opts)
end

local tmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.api.nvim_set_keymap("t", lhs, rhs, opts)
end

local tnoremap = function(lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = true
	return tmap(lhs, rhs, opts)
end

local vmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.api.nvim_set_keymap("v", lhs, rhs, opts)
end

local vnoremap = function(lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = true
	return vmap(lhs, rhs, opts)
end

local xmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.api.nvim_set_keymap("x", lhs, rhs, opts)
end

local xnoremap = function(lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = true
	return xmap(lhs, rhs, opts)
end

local cmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.api.nvim_set_keymap("c", lhs, rhs, opts)
end

local cnoremap = function(lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = true
	return cmap(lhs, rhs, opts)
end

-- bufsurf
nnoremap("Z", t(":BufSurfBack<cr>"), { silent = true })
nnoremap("X", t(":BufSurfForward<cr>"), { silent = true })

-- nvim-tree
nnoremap("<c-n>", t(":NvimTreeToggle<cr>"), { silent = true })
vim.g.nvim_tree_git_hl = 1

-- endwise
vim.g.endwise_no_mappings = 1

-- editorconfig
vim.fn["editorconfig#AddNewHook"](function(config)
	if config["vim_filetype"] ~= nil then
		vim.bo.filetype = config["vim_filetype"]
	end
	return 0 -- return 0 to show no error happened
end)

nnoremap("n", "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>", {
	silent = true,
})
nnoremap("N", "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>", {
	silent = true,
})
nnoremap("*", "*<cmd>lua require('hlslens').start()<cr>")
nnoremap("#", "#<cmd>lua require('hlslens').start()<cr>")
nnoremap("g*", "g*<cmd>lua require('hlslens').start()<cr>")
nnoremap("g#", "g#<cmd>lua require('hlslens').start()<cr>")

require("bufferline").setup({
	options = {
		numbers = function(opts)
			return opts.id
		end,
		close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
		separator_style = "slant",
	},
})

-- gitsigns
require("gitsigns").setup({
	signs = {
		add = { hl = "GitGutterAdd", text = "█│" },
		change = { hl = "GitGutterChange", text = "█┆" },
		delete = { hl = "GitGutterDelete", text = "█▁" },
		topdelete = { hl = "GitGutterDelete", text = "█▔" },
		changedelete = { hl = "GitGutterChange", text = "█▟" },
	},
})

-- colorscheme
vim.o.termguicolors = true
vim.cmd([[autocmd ColorScheme * highlight link HlSearchLens Comment]])
vim.cmd([[autocmd ColorScheme * highlight link HlSearchLensNear Comment]])

vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_palette = "original"
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
vim.g.gruvbox_material_statusline_style = "original"
vim.cmd([[colorscheme gruvbox-material]])

require("todo-comments").setup({
	keywords = {
		TODO = { icon = " ", color = "error" },
	},
	highlight = {
		keyword = "bg",
		pattern = [[.*<(KEYWORDS)\s*]],
	},
	search = {
		pattern = [[\b(KEYWORDS)]],
	},
})

-- fugitive
-- delete fugitive buffers when they are left
vim.cmd([[
  augroup InitFugitive
    autocmd!
    autocmd BufReadPost fugitive://* set bufhidden=delete
  augroup END
]])
vim.env.GIT_SSH_COMMAND = "ssh -o ControlPersist=no"
nnoremap("<leader>gs", ":Git<cr>", { silent = true })
nnoremap("<leader>gd", ":Gvdiffsplit<cr>", { silent = true })
nnoremap("<leader>gc", ":Git commit<cr>", { silent = true })
nnoremap("<leader>gb", ":Git blame<cr>", { silent = true })
nnoremap("<leader>gl", ":Gclog<cr>", { silent = true })
nnoremap("<leader>gp", ":Git push<cr>", { silent = true })
nnoremap("<leader>gr", ":GRemove<cr>", { silent = true })
nnoremap("<leader>gw", ":Gwrite<cr>", { silent = true })
nnoremap("<leader>ge", ":Gedit<cr>", { silent = true })
nnoremap("<leader>g.", ":Gcd<cr>:pwd<cr>", { silent = true })
nnoremap("<leader>gu", ":Git pull<cr>", { silent = true })
nnoremap("<leader>gn", ":Git merge<cr>", { silent = true })
nnoremap("<leader>gf", ":Git fetch<cr>", { silent = true })

-- lightline
vim.cmd([[
  augroup InitLightline
    autocmd!
    autocmd User LspDiagnosticsChanged call lightline#update()
  augroup END
]])

vim.g.lightline_readonly_filetypes = { "help", "man", "qf", "taskreport", "taskinfo" }
vim.g.lightline_filetype_mode_filetypes = { "help", "man", "qf", "defx" }
vim.g.lightline_no_lineinfo_filetypes = { "taskreport", "taskinfo", "defx" }
vim.g.lightline_no_filetype_filetypes = { "man", "help", "qf", "taskreport", "taskinfo", "defx" }
vim.g.lightline_no_filename_filetypes = { "qf", "taskreport", "taskinfo", "defx" }

vim.g.lightline = {
	colorscheme = "gruvbox_material",
	separator = { left = "", right = "" },
	subseparator = { left = "", right = "" },
	active = {
		left = {
			{ "mode", "crypt", "paste", "spell" },
			{ "filename" },
		},
		right = {
			{ "filetype", "lineinfo" },
			{ "warnings", "errors", "git" },
		},
	},
	inactive = {
		left = {
			{},
			{},
			{ "fullfilename" },
		},
		right = {
			{ "filetype" },
		},
	},
	component = {
		lambda = "λ",
	},
	component_function = {
		git = "rubix#lightline#git",
		filename = "rubix#lightline#filename",
		fullfilename = "rubix#lightline#full_filename",
		filetype = "rubix#lightline#filetype",
		mode = "rubix#lightline#mode",
		crypt = "rubix#lightline#crypt",
		spell = "rubix#lightline#spell",
		paste = "rubix#lightline#paste",
	},
	component_expand = {
		lineinfo = "rubix#lightline#line_info",
		errors = "rubix#lightline#errors",
		warnings = "rubix#lightline#warnings",
	},
	component_type = {
		errors = "error",
		warnings = "warning",
	},
	enable = {
		statusline = 1,
		tabline = 0,
	},
}

require("nvim-treesitter.configs").setup({
	ensure_installed = "maintained",
	highlight = { enable = true },
	-- indent = { enable = true }, -- TODO(jawa) this is too experimental right now, enable when possible
	context_commentstring = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})

require("treesitter-context").setup({
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	throttle = true, -- Throttles plugin updates (may improve performance)
})

-- formatter
require("formatter").setup({
	filetype = {
		lua = {
			function()
				return {
					exe = "stylua",
					args = {
						"-",
					},
					stdin = true,
				}
			end,
		},
	},
})

-- lsp
local nvim_lsp = require("lspconfig")
local on_attach = function(_, _)
	vim.cmd([[autocmd BufWritePre <buffer> lua lsp_format()]])
	vim.cmd([[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]])

	local buf_nnoremap = function(lhs, rhs)
		return vim.api.nvim_buf_set_keymap(0, "n", lhs, rhs, { noremap = true, silent = true })
	end

	buf_nnoremap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
	buf_nnoremap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
	buf_nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<cr>")
	buf_nnoremap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
	buf_nnoremap("gy", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
	buf_nnoremap("<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>")
	buf_nnoremap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
	buf_nnoremap("[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>")
	buf_nnoremap("]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>")
	buf_nnoremap("<leader>cl", "<cmd>lua vim.lsp.codelens.run()<cr>")
end

_G.lsp_format = function()
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype == "go" then
		lsp_format_go()
	else
		vim.lsp.buf.formatting_seq_sync()
	end
end

_G.lsp_format_go = function(timeout_ms)
	local context = { source = { organizeImports = true } }
	vim.validate({ context = { context, "t", true } })

	local params = vim.lsp.util.make_range_params()
	params.context = context

	local method = "textDocument/codeAction"
	local result = vim.lsp.buf_request_sync(0, method, params, timeout_ms)
	if not result then
		return
	end

	if result then
		for _, v in ipairs(result) do
			local vresult = v.result
			if vresult and vresult[1] then
				local edit = vresult[1].edit
				vim.lsp.util.apply_workspace_edit(edit)
			end
		end
	end

	vim.lsp.buf.formatting_seq_sync()
end

vim.lsp.handlers["textDocument/codeLens"] = function(err, _, result, client_id, bufnr)
	-- ignore this error since it shows up for the codelens.refresh() autocmd and
	-- is very annoying
	-- method textDocument/codeLens is not supported by any of the servers registered for the current buffer
	if err and err.code == -32601 then
		return
	end

	return vim.lsp.codelens.on_codelens(err, _, result, client_id, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local servers = { "clangd", "cmake" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

require("rust-tools").setup({
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
})

nvim_lsp.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		gopls = {
			buildFlags = { "-tags=wireinject" },
			experimentalTemplateSupport = true,
			usePlaceholders = true,
			codelenses = {
				gc_details = true,
				generate = true,
				regenerate_cgo = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
				nilness = true,
			},
			analyses = {
				fillreturns = true,
				nonewvars = true,
				shadow = true,
				undeclaredname = true,
				unreachable = true,
				unusedparams = true,
				unusedwrite = true,
			},
			gofumpt = true,
			["local"] = "go.ngrok.com",
			staticcheck = true,
		},
	},
	flags = {
		debounce_text_changes = 200,
	},
})

require("null-ls").config({})
nvim_lsp["null-ls"].setup({})

nvim_lsp.tsserver.setup({
	on_attach = function(client, bufnr)
		-- disable tsserver formatting (done by null-ls)
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false

		local ts_utils = require("nvim-lsp-ts-utils")

		ts_utils.setup({
			debug = false,
			disable_commands = false,
			enable_import_on_completion = false,

			-- eslint
			eslint_enable_code_actions = true,
			eslint_enable_disable_comments = true,
			eslint_bin = "eslint_d",
			eslint_config_fallback = nil,
			eslint_enable_diagnostics = true,

			-- formatting
			enable_formatting = true,
			formatter = "eslint_d",
			formatter_config_fallback = nil,

			-- parentheses completion
			complete_parens = false,
			signature_help_in_parens = false,

			-- update imports on file move
			update_imports_on_move = false,
			require_confirmation_on_move = false,
			watch_dir = nil,
		})

		ts_utils.setup_client(client)

		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
})

local lua_path = vim.split(package.path, ";")
table.insert(lua_path, "lua/?.lua")
table.insert(lua_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup({
	cmd = { "lua-language-server", "-E", "/usr/share/lua-language-server/main.lua" },
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = lua_path,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

vim.cmd([[sign define DiagnosticSignError text= texthl=LspDiagnosticsSignError       linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn  text= texthl=LspDiagnosticsSignWarning     linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo  text= texthl=LspDiagnosticsSignInformation linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint  text= texthl=LspDiagnosticsSignHint        linehl= numhl=]])

-- snippets
local luasnip = require("luasnip")
require("luasnip/loaders/from_vscode").lazy_load()

-- completion
local cmp = require("cmp")
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
		["<c-space>"] = cmp.mapping.complete(),
		["<c-e>"] = cmp.mapping.close(),
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
					vim.fn.feedkeys(t("<c-e>")) -- close cmp
					vim.fn.feedkeys(t("<c-]>")) -- complete abbreviations
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
				vim.fn.feedkeys(t("<plug>luasnip-expand-or-jump"))
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
				vim.fn.feedkeys(t("<plug>luasnip-jump-prev"))
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
inoremap("<plug>Endwise", t("<c-r>=EndwiseDiscretionary()<cr>"), { silent = true })

-- telescope
local telescope = require("telescope")
local telescope_actions = require("telescope.actions")
telescope.setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--with-filename",
			"--no-heading",
			"--line-number",
			"--column",
			"--hidden",
			"--smart-case",
			"--follow",
			"--color=never",
		},
		layout_config = {
			prompt_position = "top",
		},
		sorting_strategy = "ascending",
		set_env = { ["COLORTERM"] = "truecolor" },

		mappings = {
			i = {
				["<esc>"] = telescope_actions.close,
				["<c-j>"] = telescope_actions.move_selection_next,
				["<c-k>"] = telescope_actions.move_selection_previous,
			},

			n = {
				["<c-j>"] = telescope_actions.move_selection_next,
				["<c-k>"] = telescope_actions.move_selection_previous,
			},
		},

		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
			},
		},
	},
})
telescope.load_extension("fzf")
telescope.load_extension("zoxide")
telescope.load_extension("rubix")
telescope.load_extension("neoclip")
require("neoclip").setup({
	default_register = { "+", "*" },
	filter = nil,
	history = 1000,
})
nmap("<c-b>", "<cmd>Telescope buffers<cr>", { silent = true })
nmap("<leader>z", "<cmd>Telescope zoxide list<cr>", { silent = true })
nmap("<c-p>", "<cmd>Telescope rubix find_files<cr>", { silent = true })
nmap("<c-f>", "<cmd>Telescope rubix history<cr>", { silent = true })
nmap("<c-s><c-s>", "<cmd>Telescope rubix grep_string<cr>", { silent = true })
nmap("<c-s><c-d>", "<cmd>Telescope rubix live_grep<cr>", { silent = true })
nmap("<leader>y", "<cmd>Telescope neoclip plus extra=star<cr>", { silent = true })
tmap("<c-p>", "<cmd>Telescope rubix find_files<cr>", { silent = true })
tmap("<c-b>", "<cmd>Telescope buffers<cr>", { silent = true })

-- trouble
require("trouble").setup({
	position = "bottom", -- position of the list can be: bottom, top, left, right
	height = 10, -- height of the trouble list when position is top or bottom
	width = 50, -- width of the list when position is left or right
	icons = true, -- use devicons for filenames
	mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
	fold_open = "", -- icon used for open folds
	fold_closed = "", -- icon used for closed folds
	action_keys = { -- key mappings for actions in the trouble list
		-- map to {} to remove a mapping, for example:
		-- close = {},
		close = "q", -- close the list
		cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
		refresh = "r", -- manually refresh
		jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
		open_split = { "<c-x>" }, -- open buffer in new split
		open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
		open_tab = { "<c-t>" }, -- open buffer in new tab
		jump_close = { "o" }, -- jump to the diagnostic and close the list
		toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
		toggle_preview = "P", -- toggle auto_preview
		hover = "K", -- opens a small poup with the full multiline message
		preview = "p", -- preview the diagnostic location
		close_folds = { "zM", "zm" }, -- close all folds
		open_folds = { "zR", "zr" }, -- open all folds
		toggle_fold = { "zA", "za" }, -- toggle fold of current file
		previous = "k", -- preview item
		next = "j", -- next item
	},
	indent_lines = true, -- add an indent guide below the fold icons
	auto_open = false, -- automatically open the list when you have diagnostics
	auto_close = false, -- automatically close the list when you have no diagnostics
	auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
	auto_fold = false, -- automatically fold a file trouble list at creation
	signs = {
		-- icons / text used for a diagnostic
		error = "",
		warning = "",
		hint = "",
		information = "",
		other = "﫠",
	},
	use_lsp_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
})
nnoremap("<leader>xx", "<cmd>Trouble<cr>", { silent = true })
nnoremap("<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>", { silent = true })
nnoremap("<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>", { silent = true })
nnoremap("<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true })
nnoremap("<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true })
nnoremap("gr", "<cmd>Trouble lsp_references<cr>", { silent = true })

-- rubix.vim
nnoremap("<leader>m", ":call rubix#maximize_toggle()<cr>", { silent = true }) -- maximize current window
nnoremap("<leader>fa", ":call rubix#preserve('normal gg=G')<cr>", { silent = true })
nnoremap("<leader>f$", ":call rubix#trim()<cr>", { silent = true })
nnoremap("<c-w><c-w>", ":confirm :Kwbd<cr>", { silent = true }) -- ctrl-w, ctrl-w to delete the current buffer without closing the window

-- toggleterm.nvim
require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 10
		elseif term.direction == "vertical" then
			return 80
		end
	end,
	open_mapping = "<c-x>",
	direction = "float", -- "vertical" | "horizontal" | "window" | "float"
	float_opts = {
		border = "curved", -- "single" | "double" | "shadow" | "curved"
		winblend = 20,
	},
})

-- normal mode
nnoremap("<leader>n", ":nohlsearch<cr>", { silent = true })
nnoremap("<leader>fc", "/\\v^[<|=>]{7}( .*|$)<cr>") -- find merge conflict markers
nnoremap("<leader>q", ":qa<cr>", { silent = true })
nnoremap("<leader>Q", ":qa!<cr>", { silent = true })
nnoremap("<leader>cd", ":lcd %:p:h<cr>:pwd<cr>") -- switch to the directory of the open buffer
nnoremap("<leader>p", "<c-w>p") -- switch to previous window
nnoremap("<leader>=", "<c-w>=") -- adjust viewports to the same size
nnoremap("Q", ":q<cr>", { silent = true }) -- Q: Closes the window
nnoremap("W", ":w<cr>", { silent = true }) -- W: Save
nnoremap("_", ":sp<cr>", { silent = true }) -- _: Quick horizontal splits
nnoremap("<bar>", ":vsp<cr>", { silent = true }) -- |: Quick vertical splits
nnoremap("+", "<c-a>") -- +: Increment number
nnoremap("-", "<c-x>") -- -: Decrement number
nnoremap("d", '"_d') -- d: Delete into the blackhole register to not clobber the last yank
nnoremap("dd", "dd") -- dd: I use this often to yank a single line, retain its original behavior
nnoremap("c", '"_c') -- c: Change into the blackhole register to not clobber the last yank
nnoremap("<c-a>r", ":redraw!<cr>", { silent = true }) -- ctrl-a r to redraw the screen now
nnoremap("<c-h>", "<c-w>h") -- tmux style navigation
nnoremap("<c-j>", "<c-w>j") -- tmux style navigation
nnoremap("<c-k>", "<c-w>k") -- tmux style navigation
nnoremap("<c-l>", "<c-w>l") -- tmux style navigation
nnoremap("<c-a>H", "<c-w><") -- resize window
nnoremap("<c-a>L", "<c-w>>") -- resize window
nnoremap("<c-a>J", "<c-w>+") -- resize window
nnoremap("<c-a>K", "<c-w>-") -- resize window

for i = 1, 9 do
	nnoremap("<leader>" .. i, ":" .. i .. "wincmd w<cr>", { silent = true }) -- <leader>[1-9]  move to window [1-9]
	nnoremap("<leader>b" .. i, ":b" .. i .. "<cr>", { silent = true }) -- <leader>b[1-9] move to buffer [1-9]
end

-- visual mode
xnoremap("y", "y`]") -- y: Yank and go to end of selection
xnoremap("p", '"_dP') -- p: Paste in visual mode should not replace the default register with the deleted text
xnoremap("d", '"_d') -- d: Delete into the blackhole register to not clobber the last yank. To 'cut', use 'x' instead
xnoremap("<cr>", 'y:let @/ = @"<cr>:set hlsearch<cr>', { silent = true }) -- enter: Highlight visual selections
xnoremap("<", "<gv") -- <: Retain visual selection after indent
xnoremap(">", ">gv") -- >: Retain visual selection after indent
xnoremap(".", ":normal.<cr>", { silent = true }) -- .: repeats the last command on every line
xnoremap("@", ":normal@@<cr>", { silent = true }) -- @: repeats the last macro on every line
xmap("<tab>", ">") -- tab: Indent (allow recursive)
xmap("<s-tab>", "<") -- shift-tab: unindent (allow recursive)

-- visual and select mode
vnoremap("<leader>s", ":sort<cr>")
vnoremap("<c-h>", "<c-w>h") -- tmux style navigation
vnoremap("<c-j>", "<c-w>j") -- tmux style navigation
vnoremap("<c-k>", "<c-w>k") -- tmux style navigation
vnoremap("<c-l>", "<c-w>l") -- tmux style navigation
vnoremap("<c-a>H", "<c-w><") -- resize window
vnoremap("<c-a>L", "<c-w>>") -- resize window
vnoremap("<c-a>J", "<c-w>+") -- resize window
vnoremap("<c-a>K", "<c-w>-") -- resize window

-- command line mode
cnoremap("<c-j>", "<down>")
cnoremap("<c-k>", "<up>")

-- insert mode
inoremap("<c-w>", "<c-g>u<c-w>") -- ctrl-w: Delete previous word, create undo point
inoremap("<c-h>", "<esc><c-w>h") -- tmux style navigation
inoremap("<c-l>", "<esc><c-w>l") -- tmux style navigation
inoremap(
	"<c-j>",
	'pumvisible() ? "<c-n>" : lua require("cmp").visible() ? lua require("cmp").select_next_item() : "<esc><c-w>j"',
	{ expr = true }
) -- tmux style navigation
inoremap(
	"<c-k>",
	'pumvisible() ? "<c-p>" : lua require("cmp").visible() ? lua require("cmp").select_prev_item() : "<esc><c-w>k"',
	{ expr = true }
) -- tmux style navigation
inoremap("<c-a>H", "<esc><c-w><a") -- resize window
inoremap("<c-a>L", "<esc><c-w>>a") -- resize window
inoremap("<c-a>J", "<esc><c-w>+a") -- resize window
inoremap("<c-a>K", "<esc><c-w>-a") -- resize window

-- terminal mode
tnoremap("<c-h>", "<c-\\><c-n><c-w>h") -- tmux style navigation
tnoremap("<c-j>", "<c-\\><c-n><c-w>j") -- tmux style navigation
tnoremap("<c-k>", "<c-\\><c-n><c-w>k") -- tmux style navigation
tnoremap("<c-l>", "<c-\\><c-n><c-w>l") -- tmux style navigation
tnoremap("<c-a>H", "<c-\\><c-n><c-w><i") -- resize window
tnoremap("<c-a>L", "<c-\\><c-n><c-w>>i") -- resize window
tnoremap("<c-a>J", "<c-\\><c-n><c-w>+i") -- resize window
tnoremap("<c-a>K", "<c-\\><c-n><c-w>-i") -- resize window
tnoremap("<c-y>", "<c-\\><c-n><c-y>") -- scroll up one line
tnoremap("<c-u>", "<c-\\><c-n><c-u>") -- scroll up half a screen

-- abbreviations
vim.cmd([[iabbrev TODO TODO(jawa)]])
vim.cmd([[iabbrev meml me@jawa.dev]])
vim.cmd([[iabbrev weml joshua@ngrok.com]])

-- autocommands
vim.cmd([[
  augroup InitAutoCmd
    autocmd!
  augroup END
]])

-- set the window title based on the terminal title (if a term title exists)
vim.cmd([[autocmd InitAutoCmd BufEnter * let &titlestring = exists('b:term_title') ? b:term_title : '']])

-- disable search highlighting in insert mode
vim.cmd([[autocmd InitAutoCmd InsertEnter * setlocal nohlsearch]])
vim.cmd([[autocmd InitAutoCmd InsertLeave * setlocal hlsearch]])

vim.cmd([[autocmd InitAutoCmd WinEnter * checktime]]) -- check timestamp more for 'autoread'
vim.cmd([[autocmd InitAutoCmd InsertLeave * if &paste | set nopaste | echo 'nopaste' | endif]]) -- disable paste
vim.cmd([[autocmd InitAutoCmd InsertLeave * if &l:diff | diffupdate | endif]]) -- update diff

-- auto format file types that don't have lsp formatters
vim.cmd([[autocmd InitAutoCmd BufWritePost *.lua silent FormatWrite]])

-- go back to previous position of cursor if any
vim.cmd(
	[[autocmd InitAutoCmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |  execute 'normal! g`"zvzz' | endif]]
)

-- terminal autocommands
vim.cmd([[autocmd TermOpen * nnoremap <buffer> <up> i<up>]]) -- switch to insert mode and press up when in terminal normal mode
vim.cmd([[autocmd TermOpen * nnoremap <buffer> <c-r> i<c-r>]]) -- switch to insert mode and press <c-r> when in terminal normal mode
vim.cmd([[autocmd TermOpen * nnoremap <buffer> q <nop>]]) -- disable macros in terminals

-- these two lines must be last
vim.o.exrc = true -- enable per-directory .vimrc files
vim.o.secure = true -- disable unsafe commands in local .vimrc files
