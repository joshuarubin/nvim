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
	use("kevinhwang91/nvim-hlslens") -- highlight search lens
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })

	use({
		"goolord/alpha-nvim", -- lua powered greeter like startify
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").opts)
		end,
	})

	-- lsp
	use("neovim/nvim-lspconfig")
	use("simrat39/rust-tools.nvim")
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
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
	use("github/copilot.vim")

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

	use({ "akinsho/toggleterm.nvim", branch = "main" })
	use("joshuarubin/rubix.vim")
	use("joshuarubin/rubix-telescope.nvim")

	use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use({ "akinsho/bufferline.nvim", branch = "main" })

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
	use("stevearc/aerial.nvim")
	use("ray-x/lsp_signature.nvim")
	use("simnalamburt/vim-mundo")

	use({
		"lewis6991/spellsitter.nvim",
		config = function()
			require("spellsitter").setup()
		end,
	})

	use("knubie/vim-kitty-navigator")
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
vim.o.spell = true

vim.opt.isfname:remove({ "=" })

vim.g.mapleader = ","

local t = function(keys)
	return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

local nmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.keymap.set("n", lhs, rhs, opts)
end

local nremap = function(lhs, rhs, opts)
	opts = opts or {}
	opts.remap = true
	return nmap(lhs, rhs, opts)
end

local imap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.keymap.set("i", lhs, rhs, opts)
end

local tmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.keymap.set("t", lhs, rhs, opts)
end

local tremap = function(lhs, rhs, opts)
	opts = opts or {}
	opts.remap = true
	return tmap(lhs, rhs, opts)
end

local vmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.keymap.set("v", lhs, rhs, opts)
end

local xmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.keymap.set("x", lhs, rhs, opts)
end

local xremap = function(lhs, rhs, opts)
	opts = opts or {}
	opts.remap = true
	return xmap(lhs, rhs, opts)
end

local cmap = function(lhs, rhs, opts)
	opts = opts or {}
	return vim.keymap.set("c", lhs, rhs, opts)
end

-- bufsurf
nmap("Z", t(":BufSurfBack<cr>"), { silent = true })
nmap("X", t(":BufSurfForward<cr>"), { silent = true })

-- endwise
vim.g.endwise_no_mappings = 1

-- mundo
nmap("<leader>u", ":MundoToggle<cr>")

-- editorconfig
vim.fn["editorconfig#AddNewHook"](function(config)
	if config["vim_filetype"] ~= nil then
		vim.bo.filetype = config["vim_filetype"]
	end
	return 0 -- return 0 to show no error happened
end)

nmap("n", "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>", {
	silent = true,
})
nmap("N", "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>", {
	silent = true,
})
nmap("*", "*<cmd>lua require('hlslens').start()<cr>")
nmap("#", "#<cmd>lua require('hlslens').start()<cr>")
nmap("g*", "g*<cmd>lua require('hlslens').start()<cr>")
nmap("g#", "g#<cmd>lua require('hlslens').start()<cr>")

local bufferline = {
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
}

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

local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
	vim.api.nvim_create_augroup(name, {})
end

-- colorscheme
vim.o.termguicolors = true
autocmd("ColorScheme", { pattern = "*", command = "highlight link HlSearchLens Comment" })
autocmd("ColorScheme", { pattern = "*", command = "highlight link HlSearchLensNear Comment" })

vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_palette = "original"
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
vim.g.gruvbox_material_statusline_style = "original"
vim.cmd([[colorscheme gruvbox-material]])

vim.g.copilot_no_maps = 1
vim.g.copilot_assume_mapped = 1

_G.copilot_accept = function()
	-- close cmp unconditionally (don't abort as it retains inserted text)
	require("cmp").mapping.close()

	-- do copilot completion if possible
	return vim.fn["copilot#Accept"](t("<c-e>"))
end

imap("<c-e>", "v:lua.copilot_accept()", { silent = true, expr = true })

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
local fugitive_group = augroup("InitFugitive")
autocmd("BufReadPost", {
	desc = "delete fugitive buffers when they are left",
	group = fugitive_group,
	pattern = "fugitive://*",
	command = "set bufhidden=delete",
})

vim.env.GIT_SSH_COMMAND = "ssh -o ControlPersist=no"
nmap("<leader>gs", ":Git<cr>", { silent = true })
nmap("<leader>gd", ":Gvdiffsplit<cr>", { silent = true })
nmap("<leader>gc", ":Git commit<cr>", { silent = true })
nmap("<leader>gb", ":Git blame<cr>", { silent = true })
nmap("<leader>gl", ":Gclog<cr>", { silent = true })
nmap("<leader>gp", ":Git push<cr>", { silent = true })
nmap("<leader>gr", ":GRemove<cr>", { silent = true })
nmap("<leader>gw", ":Gwrite<cr>", { silent = true })
nmap("<leader>ge", ":Gedit<cr>", { silent = true })
nmap("<leader>g.", ":Gcd<cr>:pwd<cr>", { silent = true })
nmap("<leader>gu", ":Git pull<cr>", { silent = true })
nmap("<leader>gn", ":Git merge<cr>", { silent = true })
nmap("<leader>gf", ":Git fetch<cr>", { silent = true })

local lualine = {
	options = {
		theme = "gruvbox",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			"diff",
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
			},
		},
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "fugitive", "nvim-tree", "quickfix", "toggleterm" },
}

require("bufferline").setup(bufferline)
require("lualine").setup(lualine)

-- nvim-tree
nmap("<c-n>", t(":NvimTreeFindFileToggle<cr>"), { silent = true })
vim.g.nvim_tree_git_hl = 1

require("nvim-tree").setup({
	diagnostics = {
		enable = true,
		icons = {
			hint = " ",
			info = " ",
			warning = " ",
			error = " ",
		},
	},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"beancount",
		"bibtex",
		"c",
		"c_sharp",
		"clojure",
		"cmake",
		"comment",
		"commonlisp",
		"cooklang",
		"cpp",
		"css",
		"cuda",
		"erlang",
		"fennel",
		"fish",
		"fusion",
		"gdscript",
		"gleam",
		"glimmer",
		"glsl",
		"go",
		"godot_resource",
		"gomod",
		"gowork",
		"graphql",
		"hcl",
		"heex",
		"hjson",
		"hocon",
		"html",
		"http",
		"java",
		"javascript",
		"jsdoc",
		"json",
		"json5",
		"jsonc",
		"julia",
		"kotlin",
		"lalrpop",
		"latex",
		"ledger",
		"llvm",
		"lua",
		"make",
		"ninja",
		"nix",
		"norg",
		"ocaml",
		"ocaml_interface",
		"ocamllex",
		"pascal",
		"perl",
		"php",
		"pioasm",
		"prisma",
		"pug",
		"python",
		"ql",
		"query",
		"r",
		"rasi",
		"regex",
		"rst",
		"ruby",
		"rust",
		"scala",
		"scss",
		"solidity",
		"sparql",
		"supercollider",
		"surface",
		"svelte",
		"teal",
		"tlaplus",
		"toml",
		"tsx",
		"turtle",
		"typescript",
		"vala",
		"vim",
		"vue",
		"yaml",
		"yang",
		"zig",
	},
	highlight = { enable = true },
	-- indent = { enable = true },
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

local lsp_signature = require("lsp_signature")
lsp_signature.setup({})

-- aerial
local aerial = require("aerial")
aerial.setup({})
autocmd("FileType", {
	pattern = "aerial",
	command = "set nospell",
})

-- lsp
local nvim_lsp = require("lspconfig")

local lsp_format = function()
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype == "go" or filetype == "gomod" then
		lsp_format_go()
	else
		vim.lsp.buf.formatting_seq_sync()
	end
end

local on_attach = function(client, bufnr)
	aerial.on_attach(client, bufnr)
	lsp_signature.on_attach()

	autocmd("BufWritePre", {
		buffer = 0,
		callback = lsp_format,
	})

	autocmd({
		"CursorHold",
		"CursorHoldI",
		"InsertLeave",
	}, {
		buffer = 0,
		command = "silent! lua vim.lsp.codelens.refresh()",
	})

	local buf_nmap = function(lhs, rhs, opts)
		opts = opts or {}
		opts.silent = true
		opts.buffer = true
		return nmap(lhs, rhs, opts)
	end

	buf_nmap("<leader>a", "<cmd>AerialToggle!<cr>")
	buf_nmap("[[", "<cmd>AerialPrev<CR>")
	buf_nmap("]]", "<cmd>AerialNext<CR>")
	buf_nmap("{", "<cmd>AerialPrevUp<CR>")
	buf_nmap("}", "<cmd>AerialNextUp<CR>")

	buf_nmap("]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
	buf_nmap("[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

	buf_nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
	buf_nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
	buf_nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>")
	buf_nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
	buf_nmap("gy", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
	buf_nmap("<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>")
	buf_nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
	buf_nmap("[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
	buf_nmap("]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
	buf_nmap("<leader>cl", "<cmd>lua vim.lsp.codelens.run()<cr>")
end

local go_organize_imports = function(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	return vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
end

local go_format = function(result)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end

	vim.lsp.buf.formatting_seq_sync()
end

_G.lsp_format_go = function(timeout_ms)
	local result = go_organize_imports(timeout_ms)
	go_format(result)
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
			["local"] = "go.ngrok.com",
			staticcheck = true,
			expandWorkspaceToModule = true,
		},
	},
	flags = {
		debounce_text_changes = 200,
	},
})

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.eslint.with({
			prefer_local = "node_modules/.bin",
		}), -- eslint or eslint_d
		null_ls.builtins.code_actions.eslint.with({
			prefer_local = "node_modules/.bin",
		}), -- eslint or eslint_d
		null_ls.builtins.formatting.prettier.with({
			prefer_local = "node_modules/.bin",
		}), -- prettier, eslint, eslint_d, or prettierd
	},
})

nvim_lsp.tsserver.setup({
	init_options = require("nvim-lsp-ts-utils").init_options,
	on_attach = function(client, bufnr)
		-- disable tsserver formatting (done by null-ls)
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false

		local ts_utils = require("nvim-lsp-ts-utils")
		ts_utils.setup({})
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
				preloadFileSize = 150,
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
imap("<plug>Endwise", t("<c-r>=EndwiseDiscretionary()<cr>"), { silent = true })

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
	},

	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
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
nremap("<c-b>", "<cmd>Telescope buffers<cr>", { silent = true })
nremap("<leader>z", "<cmd>Telescope zoxide list<cr>", { silent = true })
nremap("<c-p>", "<cmd>Telescope rubix find_files<cr>", { silent = true })
nremap("<c-f>", "<cmd>Telescope rubix history<cr>", { silent = true })
nremap("<c-s><c-s>", "<cmd>Telescope rubix grep_string<cr>", { silent = true })
nremap("<c-s><c-d>", "<cmd>Telescope rubix live_grep<cr>", { silent = true })
nremap("<leader>y", "<cmd>Telescope neoclip plus extra=star<cr>", { silent = true })
tremap("<c-p>", "<cmd>Telescope rubix find_files<cr>", { silent = true })
tremap("<c-b>", "<cmd>Telescope buffers<cr>", { silent = true })

-- trouble
require("trouble").setup({
	position = "bottom", -- position of the list can be: bottom, top, left, right
	height = 10, -- height of the trouble list when position is top or bottom
	width = 50, -- width of the list when position is left or right
	icons = true, -- use devicons for filenames
	mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
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
nmap("<leader>xx", "<cmd>Trouble<cr>", { silent = true })
nmap("<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", { silent = true })
nmap("<leader>xd", "<cmd>Trouble document_diagnostics<cr>", { silent = true })
nmap("<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true })
nmap("<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true })
nmap("gr", "<cmd>Trouble lsp_references<cr>", { silent = true })

-- rubix.vim
nmap("<leader>m", ":call rubix#maximize_toggle()<cr>", { silent = true }) -- maximize current window
nmap("<leader>fa", ":call rubix#preserve('normal gg=G')<cr>", { silent = true })
nmap("<leader>f$", ":call rubix#trim()<cr>", { silent = true })
nmap("<c-w><c-w>", ":confirm :Kwbd<cr>", { silent = true }) -- ctrl-w, ctrl-w to delete the current buffer without closing the window

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

-- vim-kitty-navigator
vim.g.kitty_navigator_no_mappings = 1

-- normal mode
nmap("<leader>n", ":nohlsearch<cr>", { silent = true })
nmap("<leader>fc", "/\\v^[<|=>]{7}( .*|$)<cr>") -- find merge conflict markers
nmap("<leader>q", ":qa<cr>", { silent = true })
nmap("<leader>Q", ":qa!<cr>", { silent = true })
nmap("<leader>cd", ":lcd %:p:h<cr>:pwd<cr>") -- switch to the directory of the open buffer
nmap("<leader>p", "<c-w>p") -- switch to previous window
nmap("<leader>=", "<c-w>=") -- adjust viewports to the same size
nmap("Q", ":q<cr>", { silent = true }) -- Q: Closes the window
nmap("W", ":w<cr>", { silent = true }) -- W: Save
nmap("_", ":sp<cr>", { silent = true }) -- _: Quick horizontal splits
nmap("<bar>", ":vsp<cr>", { silent = true }) -- |: Quick vertical splits
nmap("+", "<c-a>") -- +: Increment number
nmap("-", "<c-x>") -- -: Decrement number
nmap("d", '"_d') -- d: Delete into the blackhole register to not clobber the last yank
nmap("dd", "dd") -- dd: I use this often to yank a single line, retain its original behavior
nmap("c", '"_c') -- c: Change into the blackhole register to not clobber the last yank
nmap("<c-a>r", ":redraw!<cr>", { silent = true }) -- ctrl-a r to redraw the screen now
nmap("<c-h>", ":KittyNavigateLeft<cr>", { silent = true }) -- tmux style navigation
nmap("<c-j>", ":KittyNavigateDown<cr>", { silent = true }) -- tmux style navigation
nmap("<c-k>", ":KittyNavigateUp<cr>", { silent = true }) -- tmux style navigation
nmap("<c-l>", ":KittyNavigateRight<cr>", { silent = true }) -- tmux style navigation
nmap("<c-a>H", "<c-w><") -- resize window
nmap("<c-a>L", "<c-w>>") -- resize window
nmap("<c-a>J", "<c-w>+") -- resize window
nmap("<c-a>K", "<c-w>-") -- resize window

for i = 1, 9 do
	nmap("<leader>" .. i, ":" .. i .. "wincmd w<cr>", { silent = true }) -- <leader>[1-9]  move to window [1-9]
	nmap("<leader>b" .. i, ":b" .. i .. "<cr>", { silent = true }) -- <leader>b[1-9] move to buffer [1-9]
end

-- visual mode
xmap("y", "y`]") -- y: Yank and go to end of selection
xmap("p", '"_dP') -- p: Paste in visual mode should not replace the default register with the deleted text
xmap("d", '"_d') -- d: Delete into the blackhole register to not clobber the last yank. To 'cut', use 'x' instead
xmap("<cr>", 'y:let @/ = @"<cr>:set hlsearch<cr>', { silent = true }) -- enter: Highlight visual selections
xmap("<", "<gv") -- <: Retain visual selection after indent
xmap(">", ">gv") -- >: Retain visual selection after indent
xmap(".", ":normal.<cr>", { silent = true }) -- .: repeats the last command on every line
xmap("@", ":normal@@<cr>", { silent = true }) -- @: repeats the last macro on every line
xremap("<tab>", ">") -- tab: Indent (allow recursive)
xremap("<s-tab>", "<") -- shift-tab: unindent (allow recursive)

-- visual and select mode
vmap("<leader>s", ":sort<cr>")
vmap("<c-h>", ":<c-u>KittyNavigateLeft<cr>", { silent = true }) -- tmux style navigation
vmap("<c-j>", ":<c-u>KittyNavigateDown<cr>", { silent = true }) -- tmux style navigation
vmap("<c-k>", ":<c-u>KittyNavigateUp<cr>", { silent = true }) -- tmux style navigation
vmap("<c-l>", ":<c-u>KittyNavigateRight<cr>", { silent = true }) -- tmux style navigation
vmap("<c-a>H", "<c-w><") -- resize window
vmap("<c-a>L", "<c-w>>") -- resize window
vmap("<c-a>J", "<c-w>+") -- resize window
vmap("<c-a>K", "<c-w>-") -- resize window

-- command line mode
cmap("<c-j>", "<down>")
cmap("<c-k>", "<up>")

-- insert mode
imap("<c-w>", "<c-g>u<c-w>") -- ctrl-w: Delete previous word, create undo point
imap("<c-h>", "<esc>:KittyNavigateLeft<cr>", { silent = true }) -- tmux style navigation
imap("<c-j>", function()
	-- tmux style navigation
	if vim.fn.pumvisible() == 1 then
		return "<c-n>"
	end
	if cmp.visible() then
		return cmp.select_next_item()
	end
	return "<esc>:KittyNavigateDown<cr>"
end, { silent = true })
imap("<c-k>", function()
	-- tmux style navigation
	if vim.fn.pumvisible() == 1 then
		return "<c-p>"
	end
	if cmp.visible() then
		return cmp.select_prev_item()
	end
	return "<esc>:KittyNavigateUp<cr>"
end, { silent = true })
imap("<c-l>", "<esc>:KittyNavigateRight<cr>", { silent = true }) -- tmux style navigation
imap("<c-a>H", "<esc><c-w><a") -- resize window
imap("<c-a>L", "<esc><c-w>>a") -- resize window
imap("<c-a>J", "<esc><c-w>+a") -- resize window
imap("<c-a>K", "<esc><c-w>-a") -- resize window

-- terminal mode
tmap("<c-h>", "<c-\\><c-n>:KittyNavigateLeft<cr>", { silent = true }) -- tmux style navigation
tmap("<c-j>", "<c-\\><c-n>:KittyNavigateDown<cr>", { silent = true }) -- tmux style navigation
tmap("<c-k>", "<c-\\><c-n>:KittyNavigateUp<cr>", { silent = true }) -- tmux style navigation
tmap("<c-l>", "<c-\\><c-n>:KittyNavigateRight<cr>", { silent = true }) -- tmux style navigation
tmap("<c-a>H", "<c-\\><c-n><c-w><i") -- resize window
tmap("<c-a>L", "<c-\\><c-n><c-w>>i") -- resize window
tmap("<c-a>J", "<c-\\><c-n><c-w>+i") -- resize window
tmap("<c-a>K", "<c-\\><c-n><c-w>-i") -- resize window
tmap("<c-y>", "<c-\\><c-n><c-y>") -- scroll up one line
tmap("<c-u>", "<c-\\><c-n><c-u>") -- scroll up half a screen

-- abbreviations
vim.cmd([[iabbrev TODO TODO(jawa)]])
vim.cmd([[iabbrev meml me@jawa.dev]])
vim.cmd([[iabbrev weml joshua@ngrok.com]])

-- autocommands
local init_group = augroup("InitAutoCmd")

autocmd("InsertEnter", {
	desc = "disable search highlighting in insert mode",
	group = init_group,
	pattern = "*",
	command = "setlocal nohlsearch",
})

autocmd("InsertLeave", {
	desc = "enable search highlighting when leaving insert mode",
	group = init_group,
	pattern = "*",
	command = "setlocal hlsearch",
})

autocmd("WinEnter", {
	desc = "check timestamp more for 'autoread'",
	group = init_group,
	pattern = "*",
	command = "checktime",
})

autocmd("InsertLeave", {
	desc = "disable paste",
	group = init_group,
	pattern = "*",
	command = "if &paste | set nopaste | echo 'nopaste' | endif",
})

autocmd("InsertLeave", {
	desc = "update diff",
	group = init_group,
	pattern = "*",
	command = "if &l:diff | diffupdate | endif",
})

autocmd("BufWritePost", {
	desc = "auto format file types that don't have lsp formatters",
	group = init_group,
	pattern = "*.lua",
	command = "silent FormatWrite",
})

autocmd("BufReadPost", {
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

-- terminal autocommands
autocmd("TermOpen", {
	desc = "switch to insert mode and press up when in terminal normal mode",
	pattern = "*",
	command = "nnoremap <buffer> <up> i<up>",
})
autocmd("TermOpen", {
	desc = "switch to insert mode and press <c-r> when in terminal normal mode",
	pattern = "*",
	command = "nnoremap <buffer> <c-r> i<c-r>",
})
autocmd("TermOpen", {
	desc = "disable macros in terminals",
	pattern = "*",
	command = "nnoremap <buffer> q <nop>",
})

-- these two lines must be last
vim.o.exrc = true -- enable per-directory .vimrc files
vim.o.secure = true -- disable unsafe commands in local .vimrc files
