-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
end

local use = require("packer").use
require("packer").startup(function()
	use("wbthomason/packer.nvim") -- package manager
	use("tpope/vim-surround") -- quoting/parenthesizing made simple
	use("tpope/vim-repeat") -- enable repeating supported plugin maps with `.`
	use("tpope/vim-eunuch") -- helpers for unix
	use("tpope/vim-endwise") -- wisely add "end" in ruby, endfunction/endif/more in vim script, etc.
	use("tpope/vim-abolish") -- easily search for, substitute, and abbreviate multiple variants of a word
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({})
		end,
	})
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("editorconfig/editorconfig-vim")
	use("kevinhwang91/nvim-hlslens") -- highlight search lens
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })

	use({
		"goolord/alpha-nvim", -- lua powered greeter like startify
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("alpha").setup(require("alpha.themes.startify").opts)
		end,
	})

	-- lsp
	use({
		"williamboman/nvim-lsp-installer",
		"neovim/nvim-lspconfig",
	})
	use("simrat39/rust-tools.nvim")
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = "nvim-lua/plenary.nvim",
	})
	use("jose-elias-alvarez/nvim-lsp-ts-utils")
	use("mfussenegger/nvim-dap")

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
	use("gbprod/yanky.nvim")

	use("folke/trouble.nvim")

	use({ "akinsho/toggleterm.nvim", branch = "main" })
	use("joshuarubin/rubix.vim")
	use("joshuarubin/rubix-telescope.nvim")

	use({
		"lewis6991/gitsigns.nvim",
		requires = "nvim-lua/plenary.nvim",
	})
	use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

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
	use({ "ellisonleao/glow.nvim", branch = "main" })
	use("kosayoda/nvim-lightbulb")
	use("stevearc/dressing.nvim")
	use("rcarriga/nvim-notify")
	use("joshuarubin/chezmoi.vim")
	use({
		"joshuarubin/terminal.nvim",
		config = function()
			require("terminal").setup()
		end,
	})
	use({
		"joshuarubin/go-return.nvim",
		branch = "main",
		requires = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
		config = function()
			require("go-return").setup()
		end,
	})
	use("lukas-reineke/indent-blankline.nvim")
	use("petertriho/nvim-scrollbar")
	use("axieax/urlview.nvim")

	use({
		"ghillb/cybu.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			local ok, cybu = pcall(require, "cybu")
			if not ok then
				return
			end
			cybu.setup({
				display_time = 1500,
			})
			vim.keymap.set("n", "Z", function()
				cybu.cycle("prev")
			end)
			vim.keymap.set("n", "X", function()
				cybu.cycle("next")
			end)
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)

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
vim.o.concealcursor = "nv"
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

vim.opt.isfname:remove({ "=" })

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.vim_json_conceal = 0

local function t(keys)
	return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

-- endwise
vim.g.endwise_no_mappings = 1

-- mundo
vim.keymap.set("n", "<leader>u", ":MundoToggle<cr>")

-- editorconfig
vim.fn["editorconfig#AddNewHook"](function(config)
	if config["vim_filetype"] ~= nil then
		vim.bo.filetype = config["vim_filetype"]
	end
	return 0 -- return 0 to show no error happened
end)

vim.keymap.set("n", "n", "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>", {
	silent = true,
})
vim.keymap.set("n", "N", "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>", {
	silent = true,
})
vim.keymap.set("n", "*", "*<cmd>lua require('hlslens').start()<cr>")
vim.keymap.set("n", "#", "#<cmd>lua require('hlslens').start()<cr>")
vim.keymap.set("n", "g*", "g*<cmd>lua require('hlslens').start()<cr>")
vim.keymap.set("n", "g#", "g#<cmd>lua require('hlslens').start()<cr>")

local bufferline = {
	options = {
		numbers = function(opts)
			return tostring(opts.id)
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

local neogit = require("neogit")
neogit.setup({
	kind = "split",
	integrations = {
		diffview = true,
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
	trouble = true,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		-- Navigation
		vim.keymap.set("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, buffer = bufnr })

		vim.keymap.set("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, buffer = bufnr })

		-- Actions
		vim.keymap.set({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { buffer = bufnr })
		vim.keymap.set({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { buffer = bufnr })
		vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr })
		vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr })
		vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr })
		vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr })
		vim.keymap.set("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end, { buffer = bufnr })
		vim.keymap.set("n", "<leader>gw", function()
			gs.blame_line({ full = true })
		end, { buffer = bufnr })
		vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, { buffer = bufnr })
		vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr })
		vim.keymap.set("n", "<leader>gd", gs.diffthis, { buffer = bufnr })
		vim.keymap.set("n", "<leader>hD", function()
			gs.diffthis("~")
		end, { buffer = bufnr })
		vim.keymap.set("n", "<leader>td", gs.toggle_deleted, { buffer = bufnr })

		-- Text object
		vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr })
	end,
})

require("scrollbar").setup({
	handle = {
		highlight = "Pmenu",
	},
	marks = {
		Search = {
			highlight = "Green",
		},
	},
	handlers = {
		diagnostic = true,
		search = true,
	},
})
require("scrollbar.handlers.search").setup()

-- colorscheme
vim.o.termguicolors = true
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", command = "highlight Comment gui=italic cterm=italic" })
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", command = "highlight link HlSearchLens Comment" })
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", command = "highlight link HlSearchLensNear Comment" })

vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_palette = "original"
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
vim.g.gruvbox_material_statusline_style = "original"
vim.cmd([[colorscheme gruvbox-material]])

vim.g.copilot_no_tab_map = 1
vim.g.copilot_assume_mapped = 1

local cmp = require("cmp")

-- not sure why, but this has func has to be available to vim
_G.copilot_accept = function()
	if cmp.visible() then
		cmp.abort()
		return ""
	end

	-- do copilot completion if possible
	return vim.fn["copilot#Accept"](t("<c-e>"))
end

-- not sure why, but the func here has to be called from vim and not lua to work properly
vim.keymap.set("i", "<c-e>", "v:lua.copilot_accept()", { silent = true, expr = true })

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

vim.env.GIT_SSH_COMMAND = "ssh -o ControlPersist=no"

local git_dir
vim.keymap.set("n", "<leader>gs", function()
	git_dir = vim.fn.expand("%:p:h")
	neogit.open({ cwd = vim.fn.expand("%:p:h") })
end)

local neogit_bindings = {
	["<leader>gc"] = "commit",
	["<leader>gl"] = "log",
	["<leader>gp"] = "push",
	["<leader>gu"] = "pull",
	["<leader>gr"] = "rebase",
	["<leader>gz"] = "stash",
	["<leader>gZ"] = "stash",
	["<leader>gb"] = "branch",
}

for k, v in pairs(neogit_bindings) do
	vim.keymap.set("n", k, function()
		git_dir = vim.fn.expand("%:p:h")
		neogit.open({ v })
	end)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "Neogit*",
	callback = function()
		vim.cmd("lcd " .. git_dir)
	end,
})

vim.keymap.set("n", "<leader>g.", function()
	vim.cmd("lcd " .. vim.fn.expand("%:p:h"))
	local dir = vim.fn.system("git rev-parse --git-dir"):gsub(".git", "")
	dir = vim.trim(dir)
	if dir ~= "" then
		dir = vim.fn.fnamemodify(dir, ":p")
		vim.cmd("lcd " .. dir)
	end
end)

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
	extensions = { "nvim-tree", "quickfix", "toggleterm" },
}

require("bufferline").setup(bufferline)
require("lualine").setup(lualine)

-- nvim-tree
vim.keymap.set("n", "<c-n>", function()
	vim.api.nvim_command("NvimTreeFindFileToggle")
end)

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
	renderer = {
		highlight_git = true,
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
	-- indent = { enable = true }, -- TODO(jawa) this is too experimental right now, enable when possible
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
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

local lsp_signature = require("lsp_signature")
lsp_signature.setup({})

-- aerial
local aerial = require("aerial")
aerial.setup({})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "aerial",
	command = "set nospell",
})

-- lsp
require("nvim-lsp-installer").setup({
	automatic_installation = true,
})

local nvim_lsp = require("lspconfig")

local function go_organize_imports(bufnr, wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	return vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, wait_ms)
end

local function go_format(result)
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

local function lsp_format_go(bufnr, timeout_ms)
	local result = go_organize_imports(bufnr, timeout_ms)
	go_format(result)
end

local function lsp_format(opts)
	opts = opts or { buf = 0 }

	if vim.b.autoformat ~= 1 then
		return
	end

	local filetype = vim.api.nvim_buf_get_option(opts.buf, "filetype")

	if filetype == "go" or filetype == "gomod" then
		lsp_format_go(opts.buf)
	else
		-- TODO(jawa) this changes format in neovim 0.8+
		vim.lsp.buf.formatting_seq_sync(nil, 5000)
	end
end

local telescope_builtin = require("telescope.builtin")

local function on_attach(client, bufnr)
	aerial.on_attach(client, bufnr)
	lsp_signature.on_attach(nil, bufnr)

	if vim.b.autoformat == nil then
		vim.b.autoformat = 1
	end

	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = lsp_format,
	})

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
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
	vim.keymap.set("n", "<leader>so", telescope_builtin.lsp_document_symbols, { buffer = bufnr })
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = bufnr })
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })
	vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = bufnr })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local servers = { "bashls", "clangd", "cmake", "dockerls", "pyright", "vimls", "zls" }
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
	on_attach = on_attach,
	sources = {
		null_ls.builtins.code_actions.eslint.with({ prefer_local = "node_modules/.bin" }), -- javascript, typescript, react and tsx
		null_ls.builtins.code_actions.shellcheck, -- sh
		null_ls.builtins.code_actions.statix, -- nix
		null_ls.builtins.diagnostics.buf, -- proto
		null_ls.builtins.diagnostics.deadnix, -- nix
		null_ls.builtins.diagnostics.eslint.with({ prefer_local = "node_modules/.bin" }), -- javascript, typescript, react and tsx,
		null_ls.builtins.diagnostics.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }), -- sql
		null_ls.builtins.diagnostics.statix, -- nix
		null_ls.builtins.diagnostics.teal, -- teal
		null_ls.builtins.diagnostics.vale, -- markdown, tex, asciidoc
		null_ls.builtins.formatting.alejandra, -- nix
		null_ls.builtins.formatting.buf, -- proto
		null_ls.builtins.formatting.prettier.with({ prefer_local = "node_modules/.bin" }), -- javascript, typescript, react, vue, css, scss, less, html, json, yaml, markdown, graphql, handlebars
		null_ls.builtins.formatting.shfmt.with({
			args = {},
		}), -- sh
		null_ls.builtins.formatting.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }), -- javascript, typescript, react and tsx
		null_ls.builtins.formatting.stylua, -- lua
		null_ls.builtins.hover.dictionary, -- text, markdown
	},
})

-- javascript, typescript, react and tsx
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
				globals = { "vim" },
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

vim.cmd([[sign define DiagnosticSignError text= texthl=LspDiagnosticsSignError       linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn  text= texthl=LspDiagnosticsSignWarning     linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo  text= texthl=LspDiagnosticsSignInformation linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint  text= texthl=LspDiagnosticsSignHint        linehl= numhl=]])

-- snippets
local luasnip = require("luasnip")
require("luasnip/loaders/from_vscode").lazy_load()

-- completion
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
vim.keymap.set("i", "<plug>Endwise", t("<c-r>=EndwiseDiscretionary()<cr>"), { silent = true })

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
require("yanky").setup()
telescope.load_extension("yank_history")

vim.keymap.set("i", "<c-v>", "<c-\\><c-n>pa", { remap = true })
vim.keymap.set("c", "<c-v>", "<c-r>+")
vim.keymap.set({ "n", "x" }, "p", "<plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<plug>(YankyGPutBefore)")
vim.keymap.set({ "n", "x" }, "<c-v>", "<plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "y", "<plug>(YankyYank)")
vim.keymap.set("n", "<leader>p", "<plug>(YankyCycleForward)")
vim.keymap.set("n", "<leader>o", "<plug>(YankyCycleBackward)")

require("dressing").setup({})
vim.notify = require("notify")

vim.keymap.set({ "n", "t" }, "<c-b>", telescope_builtin.buffers)
vim.keymap.set("n", "<leader>z", telescope.extensions.zoxide.list)
vim.keymap.set({ "n", "t" }, "<c-p>", telescope.extensions.rubix.find_files)
vim.keymap.set("n", "<c-f>", telescope.extensions.rubix.history)
vim.keymap.set("n", "<c-s><c-s>", telescope.extensions.rubix.grep_string)
vim.keymap.set("n", "<c-s><c-d>", telescope.extensions.rubix.live_grep)

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
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", { silent = true })
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", { silent = true })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true })

-- rubix.vim
vim.keymap.set("n", "<leader>m", ":call rubix#maximize_toggle()<cr>", { silent = true }) -- maximize current window
vim.keymap.set("n", "<leader>fa", ":call rubix#preserve('normal gg=G')<cr>", { silent = true })
vim.keymap.set("n", "<leader>f$", ":call rubix#trim()<cr>", { silent = true })
vim.keymap.set("n", "<c-w><c-w>", ":confirm :Kwbd<cr>", { silent = true }) -- ctrl-w, ctrl-w to delete the current buffer without closing the window

-- toggleterm.nvim
require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return 80
		end
	end,
	shade_terminals = false,
	open_mapping = "<c-x>",
	start_in_insert = false,
	direction = "horizontal", -- "vertical" | "horizontal" | "window" | "float"
	float_opts = {
		border = "single", -- "single" | "double" | "shadow" | "curved"
		winblend = 20,
	},
})

local Terminal = require("toggleterm.terminal").Terminal
vim.keymap.set("n", "<leader>gg", function()
	Terminal
		:new({
			cmd = "lazygit",
			dir = vim.fn.expand("%:p:h"),
			direction = "float",
		})
		:toggle()
end)

-- vim-kitty-navigator
vim.g.kitty_navigator_no_mappings = 1

-- glow
vim.g.glow_use_pager = true
vim.g.glow_border = "rounded"

require("nvim-lightbulb").setup({
	sign = {
		enabled = false,
	},
	virtual_text = {
		enabled = true,
	},
	autocmd = {
		enabled = true,
		pattern = { "*" },
		events = { "CursorHold", "CursorHoldI" },
	},
})

require("indent_blankline").setup({
	show_trailing_blankline_indent = false,
})

local term = require("terminal")

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
term.save.wrap("n", "<c-h>", ":KittyNavigateLeft<cr>") -- tmux style navigation
term.save.wrap("n", "<c-j>", ":KittyNavigateDown<cr>") -- tmux style navigation
term.save.wrap("n", "<c-k>", ":KittyNavigateUp<cr>") -- tmux style navigation
term.save.wrap("n", "<c-l>", ":KittyNavigateRight<cr>") -- tmux style navigation
vim.keymap.set("n", "<c-a>H", "<c-w><") -- resize window
vim.keymap.set("n", "<c-a>L", "<c-w>>") -- resize window
vim.keymap.set("n", "<c-a>J", "<c-w>+") -- resize window
vim.keymap.set("n", "<c-a>K", "<c-w>-") -- resize window

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
term.save.wrap("v", "<c-h>", ":<c-u>KittyNavigateLeft<cr>") -- tmux style navigation
term.save.wrap("v", "<c-j>", ":<c-u>KittyNavigateDown<cr>") -- tmux style navigation
term.save.wrap("v", "<c-k>", ":<c-u>KittyNavigateUp<cr>") -- tmux style navigation
term.save.wrap("v", "<c-l>", ":<c-u>KittyNavigateRight<cr>") -- tmux style navigation
vim.keymap.set("v", "<c-a>H", "<c-w><") -- resize window
vim.keymap.set("v", "<c-a>L", "<c-w>>") -- resize window
vim.keymap.set("v", "<c-a>J", "<c-w>+") -- resize window
vim.keymap.set("v", "<c-a>K", "<c-w>-") -- resize window

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
vim.keymap.set("i", "<c-h>", "<esc>:KittyNavigateLeft<cr>", { silent = true }) -- tmux style navigation
vim.keymap.set("i", "<c-j>", function()
	-- tmux style navigation
	if vim.fn.pumvisible() == 1 then
		return "<c-n>"
	end
	if cmp.visible() then
		return cmp.select_next_item()
	end
	return "<esc>:KittyNavigateDown<cr>"
end, { silent = true })
vim.keymap.set("i", "<c-k>", function()
	-- tmux style navigation
	if vim.fn.pumvisible() == 1 then
		return "<c-p>"
	end
	if cmp.visible() then
		return cmp.select_prev_item()
	end
	return "<esc>:KittyNavigateUp<cr>"
end, { silent = true })
vim.keymap.set("i", "<c-l>", "<esc>:KittyNavigateRight<cr>", { silent = true }) -- tmux style navigation
vim.keymap.set("i", "<c-a>H", "<esc><c-w><a") -- resize window
vim.keymap.set("i", "<c-a>L", "<esc><c-w>>a") -- resize window
vim.keymap.set("i", "<c-a>J", "<esc><c-w>+a") -- resize window
vim.keymap.set("i", "<c-a>K", "<esc><c-w>-a") -- resize window

-- terminal mode
term.save.wrap("t", "<c-h>", "<c-\\><c-n>:KittyNavigateLeft<cr>") -- tmux style navigation
term.save.wrap("t", "<c-j>", "<c-\\><c-n>:KittyNavigateDown<cr>") -- tmux style navigation
term.save.wrap("t", "<c-k>", "<c-\\><c-n>:KittyNavigateUp<cr>") -- tmux style navigation
term.save.wrap("t", "<c-l>", "<c-\\><c-n>:KittyNavigateRight<cr>") -- tmux style navigation
vim.keymap.set("t", "<c-a>H", "<c-\\><c-n><c-w><i") -- resize window
vim.keymap.set("t", "<c-a>L", "<c-\\><c-n><c-w>>i") -- resize window
vim.keymap.set("t", "<c-a>J", "<c-\\><c-n><c-w>+i") -- resize window
vim.keymap.set("t", "<c-a>K", "<c-\\><c-n><c-w>-i") -- resize window
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

vim.api.nvim_create_autocmd("FileType", {
	desc = "set glow preview mapping for markdown files",
	group = init_group,
	pattern = "markdown",
	callback = function()
		vim.keymap.set("n", "<leader>p", ":Glow<cr>", { silent = true, buffer = true })
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
