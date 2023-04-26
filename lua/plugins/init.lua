return {
	"tpope/vim-surround", -- quoting/parenthesizing made simple
	"tpope/vim-repeat", -- enable repeating supported plugin maps with `.`
	"tpope/vim-eunuch", -- helpers for unix

	{
		"tpope/vim-endwise",
		config = function()
			vim.g.endwise_no_mappings = 1

			vim.keymap.set(
				"i",
				"<plug>Endwise",
				vim.api.nvim_replace_termcodes("<c-r>=EndwiseDiscretionary()<cr>", true, true, true),
				{ silent = true }
			)
		end,
	},

	"tpope/vim-abolish", -- easily search for, substitute, and abbreviate multiple variants of a word

	{
		"numToStr/Comment.nvim",
		config = function()
			local ok, comment = pcall(require, "Comment")
			if not ok then
				vim.notify("Comment.nvim not found", vim.log.levels.WARN)
				return
			end

			comment.setup({})
		end,
	},

	{
		"editorconfig/editorconfig-vim",
		config = function()
			pcall(vim.call, "editorconfig#AddNewHook", function(config)
				if config["vim_filetype"] ~= nil then
					vim.bo.filetype = config["vim_filetype"]
				end

				return 0 -- return 0 to show no error happened
			end)
		end,
	},

	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			local ok, hlslens = pcall(require, "hlslens")
			if not ok then
				vim.notify("hlslens not found", vim.log.levels.WARN)
				return
			end
			hlslens.setup()
		end,
		keys = {
			{
				"n",
				"<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>",
				"n",
				{ silent = true },
			},
			{
				"N",
				"<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
				"n",
				{ silent = true },
			},
			{
				"*",
				"*<cmd>lua require('hlslens').start()<cr>",
			},
			{
				"#",
				"#<cmd>lua require('hlslens').start()<cr>",
			},
			{
				"g*",
				"g*<cmd>lua require('hlslens').start()<cr>",
			},
			{
				"g#",
				"g#<cmd>lua require('hlslens').start()<cr>",
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local ok, nvim_treesitter_configs = pcall(require, "nvim-treesitter.configs")
			if not ok then
				vim.notify("nvim-treesitter.configs not found", vim.log.levels.WARN)
				return
			end

			nvim_treesitter_configs.setup({
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
		end,
	},

	"nvim-treesitter/nvim-treesitter-textobjects",

	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local ok, todo_comments = pcall(require, "todo-comments")
			if not ok then
				vim.notify("todo-comments not found", vim.log.levels.WARN)
				return
			end

			todo_comments.setup({
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
		end,
	},

	{
		"goolord/alpha-nvim", -- lua powered greeter like startify
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		priority = 100,
		config = function()
			local ok, alpha = pcall(require, "alpha")
			if not ok then
				vim.notify("alpha not found", vim.log.levels.WARN)
				return
			end

			alpha.setup(require("alpha.themes.startify").opts)
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local ok, telescope = pcall(require, "telescope")
			if not ok then
				vim.notify("telescope not found", vim.log.levels.WARN)
				return
			end

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

			vim.keymap.set({ "n", "t" }, "<c-b>", require("telescope.builtin").buffers)
		end,
	},

	-- lsp
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	"simrat39/rust-tools.nvim",
	"onsails/lspkind.nvim",

	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	"jose-elias-alvarez/nvim-lsp-ts-utils",

	-- completion
	"hrsh7th/nvim-cmp",
	{
		"hrsh7th/cmp-path",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-buffer",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-calc",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-emoji",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-nvim-lua",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"saadparwaiz1/cmp_luasnip",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},

	{
		"github/copilot.vim",
		cond = vim.env.COPILOT_DISABLED ~= "1",
		config = function()
			vim.g.copilot_no_tab_map = 1
			vim.g.copilot_assume_mapped = 1

			local ok, cmp = pcall(require, "cmp")
			if not ok then
				vim.notify("cmp not found", vim.log.levels.WARN)
				return
			end

			vim.keymap.set("i", "<m-]>", "<plug>(copilot-next)")
			vim.keymap.set("i", "<m-[>", "<plug>(copilot-previous)")

			vim.keymap.set("i", "<c-e>", function()
				if cmp.visible() then
					cmp.abort()
					return ""
				end

				local fallback = vim.api.nvim_replace_termcodes("<c-e>", true, true, true)

				-- do copilot completion if possible
				return vim.fn["copilot#Accept"](fallback)
			end, { silent = true, expr = true, replace_keycodes = false, remap = true })
		end,
	},

	-- snippets
	"L3MON4D3/LuaSnip",
	"rafamadriz/friendly-snippets",

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		build = "make",
		config = function()
			local ok, telescope = pcall(require, "telescope")
			if not ok then
				vim.notify("telescope not found", vim.log.levels.WARN)
				return
			end

			telescope.load_extension("fzf")
		end,
	},

	{
		"jvgrootveld/telescope-zoxide",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local ok, telescope = pcall(require, "telescope")
			if not ok then
				vim.notify("telescope not found", vim.log.levels.WARN)
				return
			end

			telescope.load_extension("zoxide")

			vim.keymap.set("n", "<leader>z", telescope.extensions.zoxide.list)
		end,
	},

	{
		"gbprod/yanky.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local ok, yanky = pcall(require, "yanky")
			if not ok then
				vim.notify("yanky not found", vim.log.levels.WARN)
				return
			end

			yanky.setup()

			local mappings = {
				p = "YankyPutAfter",
				P = "YankyPutBefore",
				gp = "YankyGPutAfter",
				gP = "YankyGPutBefore",
			}

			for key, yanky_action in pairs(mappings) do
				local action = "<plug>(" .. yanky_action .. ")"

				-- paste in visual mode should not replace the default register with the deleted text
				if yanky_action == "YankyPutAfter" then
					vim.keymap.set("x", key, '"_d<plug>(YankyPutBefore)')
				elseif yanky_action == "YankyGPutBefore" then
					vim.keymap.set("x", key, '"_d<plug>(YankyGPutAfter)')
				else
					vim.keymap.set("x", key, '"_d' .. action)
				end

				vim.keymap.set("n", key, action)
			end

			-- preserve cursor position on yank (in normal mode only)
			vim.keymap.set("n", "y", "<plug>(YankyYank)")

			vim.keymap.set("n", "<leader>p", "<plug>(YankyCycleForward)")
			vim.keymap.set("n", "<leader>o", "<plug>(YankyCycleBackward)")

			if vim.g.neovide then
				vim.keymap.set({ "n", "x" }, "<d-c>", "<plug>(YankyYank)")
			end

			local telescope
			ok, telescope = pcall(require, "telescope")
			if not ok then
				vim.notify("telescope not found", vim.log.levels.WARN)
				return
			end

			telescope.load_extension("yank_history")
		end,
	},

	{
		"folke/trouble.nvim",
		config = function()
			local ok, trouble = pcall(require, "trouble")
			if not ok then
				vim.notify("trouble not found", vim.log.levels.WARN)
				return
			end

			trouble.setup({
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
		end,
	},

	{
		"akinsho/toggleterm.nvim",
		branch = "main",
		config = function()
			local ok, toggleterm = pcall(require, "toggleterm")
			if not ok then
				vim.notify("toggleterm not found", vim.log.levels.WARN)
				return
			end

			toggleterm.setup({
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
				if vim.fn.executable("lazygit") == 0 then
					vim.notify("lazygit not found", vim.log.levels.WARN)
					return
				end
				Terminal:new({
					cmd = "lazygit",
					dir = vim.fn.expand("%:p:h"),
					direction = "float",
				}):toggle()
			end)
		end,
	},

	{
		"joshuarubin/rubix.vim",
		config = function()
			local ok, rubix = pcall(require, "rubix")
			if not ok then
				vim.notify("rubix not found", vim.log.levels.WARN)
				return
			end

			rubix.setup()

			vim.keymap.set("n", "<leader>fa", ":call rubix#preserve('normal gg=G')<cr>", { silent = true })
			vim.keymap.set("n", "<leader>f$", ":call rubix#trim()<cr>", { silent = true })
			vim.keymap.set("n", "<c-w><c-w>", ":confirm :Kwbd<cr>", { silent = true }) -- ctrl-w, ctrl-w to delete the current buffer without closing the window
		end,
	},

	{
		"joshuarubin/rubix-telescope.nvim",
		dependencies = {
			"joshuarubin/rubix.vim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local ok, telescope = pcall(require, "telescope")
			if not ok then
				vim.notify("telescope not found", vim.log.levels.WARN)
				return
			end

			telescope.load_extension("rubix")

			vim.keymap.set({ "n", "t" }, "<c-p>", telescope.extensions.rubix.find_files)
			vim.keymap.set("n", "<c-f>", telescope.extensions.rubix.history)
			vim.keymap.set("n", "<c-s><c-s>", telescope.extensions.rubix.grep_string)
			vim.keymap.set("n", "<c-s><c-d>", telescope.extensions.rubix.live_grep)
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local ok, gitsigns = pcall(require, "gitsigns")
			if not ok then
				vim.notify("gitsigns not found", vim.log.levels.WARN)
				return
			end

			gitsigns.setup({
				signs = {
					add = { hl = "GitGutterAdd", text = "█│" },
					change = { hl = "GitGutterChange", text = "█┆" },
					delete = { hl = "GitGutterDelete", text = "█▁" },
					topdelete = { hl = "GitGutterDelete", text = "█▔" },
					changedelete = { hl = "GitGutterChange", text = "█▟" },
				},
				trouble = true,
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 0,
				},
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
		end,
	},

	{
		"TimUntersberger/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local ok, neogit = pcall(require, "neogit")
			if not ok then
				vim.notify("neogit not found", vim.log.levels.WARN)
				return
			end

			neogit.setup({
				kind = "split",
				integrations = {
					diffview = true,
				},
			})

			local git_dir = function(file)
				file = file or "%"
				local file_dir = vim.fn.expand(file .. ":p:h")
				local handle = io.popen("cd " .. file_dir .. " && git rev-parse --git-dir")
				if handle == nil then
					return ""
				end

				local dir = handle:read("*a")
				if dir:find("/", 1, true) == nil then
					dir = vim.fn.simplify(file_dir .. "/" .. dir)
				end
				dir = dir:gsub(".git", "")

				local result = vim.fn.fnamemodify(dir, ":p")
				handle:close()
				return result
			end

			local git_opts = {}
			vim.keymap.set("n", "<leader>gs", function()
				git_opts.dir = git_dir()
				neogit.open({ cwd = git_opts.dir })
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
					git_opts.dir = git_dir()
					neogit.open({ v })
				end)
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "Neogit*",
				callback = function()
					vim.cmd("lcd " .. git_opts.dir)
				end,
			})
		end,
	},

	{
		"sindrets/diffview.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local ok, lualine = pcall(require, "lualine")
			if not ok then
				vim.notify("lualine not found", vim.log.levels.WARN)
				return
			end

			vim.o.ruler = false

			lualine.setup({
				options = {
					theme = "gruvbox",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = {
						"mode",
					},
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
			})
		end,
	},

	{
		"akinsho/bufferline.nvim",
		branch = "main",
		config = function()
			local ok, bufferline = pcall(require, "bufferline")
			if not ok then
				vim.notify("bufferline not found", vim.log.levels.WARN)
				return
			end

			bufferline.setup({
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
			})
		end,
	},

	-- file type icons
	"ryanoasis/vim-devicons",
	"nvim-tree/nvim-web-devicons",

	-- colorscheme
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_palette = "original"
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
			vim.g.gruvbox_material_statusline_style = "original"

			pcall(vim.cmd, [[colorscheme gruvbox-material]])
		end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			local ok, colorizer = pcall(require, "colorizer")
			if not ok then
				vim.notify("colorizer not found", vim.log.levels.WARN)
				return
			end
			colorizer.setup()
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local ok, nvim_tree = pcall(require, "nvim-tree")
			if not ok then
				vim.notify("nvim-tree not found", vim.log.levels.WARN)
				return
			end

			nvim_tree.setup({
				disable_netrw = true,
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
				filters = {
					custom = { "^\\.git" },
				},
			})

			vim.keymap.set("n", "<c-n>", function()
				vim.api.nvim_command("NvimTreeFindFileToggle")
			end)
		end,
	},

	{
		"stevearc/aerial.nvim",
		config = function()
			local ok, aerial = pcall(require, "aerial")
			if not ok then
				vim.notify("aerial not found", vim.log.levels.WARN)
				return
			end

			aerial.setup({})

			vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>", { buffer = bufnr, silent = true })
			vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { buffer = bufnr, silent = true })
			vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { buffer = bufnr, silent = true })
			vim.keymap.set("n", "{", "<cmd>AerialPrevUp<CR>", { buffer = bufnr, silent = true })
			vim.keymap.set("n", "}", "<cmd>AerialNextUp<CR>", { buffer = bufnr, silent = true })
		end,
	},

	{
		"ray-x/lsp_signature.nvim",
		config = function()
			local ok, lsp_signature = pcall(require, "lsp_signature")
			if not ok then
				vim.notify("lsp_signature not found", vim.log.levels.WARN)
				return
			end

			lsp_signature.setup({})
		end,
	},

	{
		"simnalamburt/vim-mundo",
		config = function()
			vim.keymap.set("n", "<leader>u", ":MundoToggle<cr>")
		end,
	},

	{
		"ellisonleao/glow.nvim",
		branch = "main",
		config = function()
			vim.g.glow_use_pager = true
			vim.g.glow_border = "rounded"

			vim.api.nvim_create_autocmd("FileType", {
				desc = "set glow preview mapping for markdown files",
				pattern = "markdown",
				callback = function()
					vim.keymap.set("n", "<leader>p", ":Glow<cr>", { silent = true, buffer = true })
				end,
			})
		end,
	},

	{
		"kosayoda/nvim-lightbulb",
		config = function()
			local ok, nvim_lightbulb = pcall(require, "nvim-lightbulb")
			if not ok then
				vim.notify("nvim-lightbulb not found", vim.log.levels.WARN)
				return
			end

			nvim_lightbulb.setup({
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
		end,
	},

	{
		"stevearc/dressing.nvim",
		config = function()
			local ok, dressing = pcall(require, "dressing")
			if not ok then
				vim.notify("dressing not found", vim.log.levels.WARN)
				return
			end

			dressing.setup({})
		end,
	},

	{
		"rcarriga/nvim-notify",
		config = function()
			local ok, notify = pcall(require, "notify")
			if not ok then
				vim.notify("notify not found", vim.log.levels.WARN)
				return
			end

			notify.setup({})
			vim.notify = notify
		end,
	},

	"joshuarubin/chezmoi.vim",

	{
		"joshuarubin/terminal.nvim",
		config = function()
			local ok, term = pcall(require, "rubix-terminal")
			if not ok then
				vim.notify("rubix-terminal not found", vim.log.levels.WARN)
				return
			end
			term.setup()
		end,
	},

	{
		"joshuarubin/go-return.nvim",
		branch = "main",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local ok, go_return = pcall(require, "go-return")
			if not ok then
				vim.notify("go-return not found", vim.log.levels.WARN)
				return
			end

			go_return.setup()
		end,
	},

	{
		"smjonas/inc-rename.nvim",
		config = function()
			local ok, inc_rename = pcall(require, "inc_rename")
			if not ok then
				vim.notify("inc_rename not found", vim.log.levels.WARN)
				return
			end

			inc_rename.setup({
				input_buffer_type = "dressing",
			})
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local ok, indent_blankline = pcall(require, "indent_blankline")
			if not ok then
				vim.notify("indent_blankline not found", vim.log.levels.WARN)
				return
			end

			indent_blankline.setup({
				show_trailing_blankline_indent = false,
			})
		end,
	},

	"axieax/urlview.nvim",

	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_auto_close = 0
		end,
	},

	{
		"folke/zen-mode.nvim",
		config = function()
			local ok, zen = pcall(require, "zen-mode")
			if not ok then
				vim.notify("zen-mode not found", vim.log.levels.WARN)
				return
			end
			zen.setup({
				window = {
					width = 0.618,
				},
				plugins = {
					wezterm = {
						enabled = true,
						font = "+1", -- (10% increase per step)
					},
				},
			})

			vim.keymap.set("n", "<leader>m", ":ZenMode<cr>", { silent = true })
		end,
	},

	{
		"folke/twilight.nvim",
		config = function()
			local ok, twilight = pcall(require, "twilight")
			if not ok then
				vim.notify("twilight not found", vim.log.levels.WARN)
				return
			end

			twilight.setup()
		end,
	},

	{
		"joshuarubin/cybu.nvim",
		branch = "buf-history-order",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local ok, cybu = pcall(require, "cybu")
			if not ok then
				vim.notify("cybu not found", vim.log.levels.WARN)
				return
			end
			cybu.setup({
				display_time = 1500,
				style = {
					highlights = {
						current_buffer = "Comment",
						adjacent_buffers = "Visual",
					},
				},
			})
			vim.keymap.set("n", "Z", function()
				cybu.cycle("prev")
			end)
			vim.keymap.set("n", "X", function()
				cybu.cycle("next")
			end)
		end,
	},

	{
		"ojroques/vim-oscyank",
		config = function()
			vim.g.oscyank_silent = 1
		end,
	},

	"lukas-reineke/cmp-rg",

	{
		"SmiteshP/nvim-navic",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},

	{
		"utilyre/barbecue.nvim",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		config = function()
			local ok, barbecue = pcall(require, "barbecue")
			if not ok then
				vim.notify("barbecue not found", vim.log.levels.WARN)
				return
			end
			barbecue.setup()
		end,
	},

	{
		"numToStr/Navigator.nvim",
		config = function()
			local ok, navigator = pcall(require, "Navigator")
			if not ok then
				vim.notify("Navigator not found", vim.log.levels.WARN)
				return
			end
			navigator.setup({})
		end,
	},

	"hashivim/vim-terraform",
}
