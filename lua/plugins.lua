-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.o.runtimepath = install_path .. "," .. vim.o.runtimepath
end

local packer_user_config = vim.api.nvim_create_augroup("packer_user_config", {})

vim.api.nvim_create_autocmd("BufWritePost", {
	desc = "compile packer when the plugins.lua file is saved",
	group = packer_user_config,
	pattern = "plugins.lua",
	command = "source <afile> | PackerCompile",
})

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim") -- package manager
		use("tpope/vim-surround") -- quoting/parenthesizing made simple
		use("tpope/vim-repeat") -- enable repeating supported plugin maps with `.`
		use("tpope/vim-eunuch") -- helpers for unix

		-- wisely add "end" in ruby, endfunction/endif/more in vim script, etc.
		use({
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
		})

		use("tpope/vim-abolish") -- easily search for, substitute, and abbreviate multiple variants of a word

		use({
			"numToStr/Comment.nvim",
			config = function()
				local ok, comment = pcall(require, "Comment")
				if not ok then
					vim.notify("Comment.nvim not found", vim.log.levels.WARN)
					return
				end

				comment.setup({})
			end,
		})

		use("JoosepAlviste/nvim-ts-context-commentstring")

		use({
			"editorconfig/editorconfig-vim",
			config = function()
				pcall(vim.call, "editorconfig#AddNewHook", function(config)
					if config["vim_filetype"] ~= nil then
						vim.bo.filetype = config["vim_filetype"]
					end

					return 0 -- return 0 to show no error happened
				end)
			end,
		})

		-- highlight search lens
		use({
			"kevinhwang91/nvim-hlslens",
			config = function()
				vim.keymap.set(
					"n",
					"n",
					"<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>",
					{
						silent = true,
					}
				)
				vim.keymap.set(
					"n",
					"N",
					"<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
					{
						silent = true,
					}
				)
				vim.keymap.set("n", "*", "*<cmd>lua require('hlslens').start()<cr>")
				vim.keymap.set("n", "#", "#<cmd>lua require('hlslens').start()<cr>")
				vim.keymap.set("n", "g*", "g*<cmd>lua require('hlslens').start()<cr>")
				vim.keymap.set("n", "g#", "g#<cmd>lua require('hlslens').start()<cr>")
			end,
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			run = function()
				if vim.fn.exists(":TSUpdate") > 0 then
					vim.fn.TSUpdate()
				end
			end,
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
		})

		use({ "nvim-treesitter/nvim-treesitter-textobjects" })

		use({
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
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
		})

		use({
			"goolord/alpha-nvim", -- lua powered greeter like startify
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				local ok, alpha = pcall(require, "alpha")
				if not ok then
					vim.notify("alpha not found", vim.log.levels.WARN)
					return
				end

				alpha.setup(require("alpha.themes.startify").opts)
			end,
		})

		use({
			"rmagatti/auto-session",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				local ok, auto_session = pcall(require, "auto-session")
				if not ok then
					vim.notify("auto-session not found", vim.log.levels.WARN)
					return
				end

				local function restore_nvim_tree()
					local nvim_tree = require("nvim-tree")
					nvim_tree.change_dir(vim.fn.getcwd())

					local reloaders = require("nvim-tree.actions.reloaders")
					reloaders.reload_explorer()
				end

				auto_session.setup({
					auto_session_enable_last_session = false,
					auto_save_enabled = true,
					auto_restore_enabled = true,
					auto_session_suppress_dirs = { "~/" },
					pre_save_cmds = { "tabdo NvimTreeClose" },
					post_save_cmds = { "tabdo NvimTreeOpen", "tabdo wincmd p" },
					pre_restore_cmds = { "let g:terminal_autoinsert = 0" },
					post_restore_cmds = {
						restore_nvim_tree,
						"tabdo NvimTreeOpen",
						"tabdo wincmd p",
						"unlet g:terminal_autoinsert",
					},
				})

				vim.keymap.set("n", "<leader>s", "<cmd>SearchSession<cr>")
			end,
		})

		use({
			"rmagatti/session-lens",
			requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
			config = function()
				local ok, session_lens = pcall(require, "session-lens")
				if not ok then
					vim.notify("session-lens not found", vim.log.levels.WARN)
					return
				end

				session_lens.setup({})

				local telescope
				ok, telescope = pcall(require, "telescope")
				if not ok then
					vim.notify("telescope not found", vim.log.levels.WARN)
					return
				end

				telescope.load_extension("session-lens")
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

		use({
			"github/copilot.vim",
			cond = function()
				return vim.env.COPILOT_DISABLED ~= "1"
			end,
			config = function()
				vim.g.copilot_no_tab_map = 1
				vim.g.copilot_assume_mapped = 1

				local ok, cmp = pcall(require, "cmp")
				if not ok then
					vim.notify("cmp not found", vim.log.levels.WARN)
					return
				end

				-- not sure why, but this has func has to be available to vim
				_G.copilot_accept = function()
					if cmp.visible() then
						cmp.abort()
						return ""
					end

					-- do copilot completion if possible
					return vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<c-e>", true, true, true))
				end

				-- not sure why, but the func here has to be called from vim and not lua to work properly
				vim.keymap.set("i", "<c-e>", "v:lua.copilot_accept()", { silent = true, expr = true })
			end,
		})

		-- snippets
		use("L3MON4D3/LuaSnip")
		use("rafamadriz/friendly-snippets")

		-- telescope
		use({
			"nvim-telescope/telescope.nvim",
			requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
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
		})

		use({
			"nvim-telescope/telescope-fzf-native.nvim",
			requires = { "nvim-telescope/telescope.nvim" },
			run = "make",
			config = function()
				local ok, telescope = pcall(require, "telescope")
				if not ok then
					vim.notify("telescope not found", vim.log.levels.WARN)
					return
				end

				telescope.load_extension("fzf")
			end,
		})

		use({
			"jvgrootveld/telescope-zoxide",
			requires = { "nvim-telescope/telescope.nvim" },
			config = function()
				local ok, telescope = pcall(require, "telescope")
				if not ok then
					vim.notify("telescope not found", vim.log.levels.WARN)
					return
				end

				telescope.load_extension("zoxide")

				vim.keymap.set("n", "<leader>z", telescope.extensions.zoxide.list)
			end,
		})

		use({
			"gbprod/yanky.nvim",
			requires = { "nvim-telescope/telescope.nvim" },
			config = function()
				local ok, yanky = pcall(require, "yanky")
				if not ok then
					vim.notify("yanky not found", vim.log.levels.WARN)
					return
				end

				yanky.setup()

				local noOverwriteReg = function(yanky_action)
					return function()
						local select_last_visual = "gv"
						local yank_to_last_reg = '"' .. vim.v.register .. "y"
						local restore_cursor_pos = "'>"

						return yanky_action .. select_last_visual .. yank_to_last_reg .. restore_cursor_pos
					end
				end

				local mappings = {
					p = "YankyPutAfter",
					P = "YankyPutBefore",
					gp = "YankyGPutAfter",
					gP = "YankyGPutBefore",
					y = "YankyYank",
				}

				for key, yanky_action in pairs(mappings) do
					vim.keymap.set("x", key, noOverwriteReg("<plug>(" .. yanky_action .. ")"), { expr = true })
					vim.keymap.set("n", key, "<plug>(" .. yanky_action .. ")")
				end

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
		})

		use({
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
		})

		use({
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
					Terminal:new({
						cmd = "lazygit",
						dir = vim.fn.expand("%:p:h"),
						direction = "float",
					}):toggle()
				end)
			end,
		})

		use({
			"joshuarubin/rubix.vim",
			config = function()
				local ok, rubix = pcall(require, "rubix")
				if not ok then
					vim.notify("rubix not found", vim.log.levels.WARN)
					return
				end

				rubix.setup()

				vim.keymap.set("n", "<leader>m", ":call rubix#maximize_toggle()<cr>", { silent = true }) -- maximize current window
				vim.keymap.set("n", "<leader>fa", ":call rubix#preserve('normal gg=G')<cr>", { silent = true })
				vim.keymap.set("n", "<leader>f$", ":call rubix#trim()<cr>", { silent = true })
				vim.keymap.set("n", "<c-w><c-w>", ":confirm :Kwbd<cr>", { silent = true }) -- ctrl-w, ctrl-w to delete the current buffer without closing the window
			end,
		})

		use({
			"joshuarubin/rubix-telescope.nvim",
			requires = { "nvim-telescope/telescope.nvim" },
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
		})

		use({
			"lewis6991/gitsigns.nvim",
			requires = "nvim-lua/plenary.nvim",
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
		})

		use({
			"TimUntersberger/neogit",
			requires = "nvim-lua/plenary.nvim",
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
			end,
		})

		use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
			config = function()
				local ok, lualine = pcall(require, "lualine")
				if not ok then
					vim.notify("lualine not found", vim.log.levels.WARN)
					return
				end

				local auto_session_lib
				ok, auto_session_lib = pcall(require, "auto-session-library")
				if not ok then
					vim.notify("auto-session-library not found", vim.log.levels.WARN)
					return
				end

				lualine.setup({
					options = {
						theme = "gruvbox",
						component_separators = { left = "", right = "" },
						section_separators = { left = "", right = "" },
					},
					sections = {
						lualine_a = {
							"mode",
							auto_session_lib.current_session_name,
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
		})

		use({
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
		})

		-- file type icons
		use("ryanoasis/vim-devicons")
		use("kyazdani42/nvim-web-devicons")

		-- colorscheme
		use({
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
		})

		use("folke/lsp-colors.nvim")

		use({
			"norcalli/nvim-colorizer.lua",
			config = function()
				local ok, colorizer = pcall(require, "colorizer")
				if not ok then
					vim.notify("colorizer not found", vim.log.levels.WARN)
					return
				end
				colorizer.setup()
			end,
		})

		use({
			"kyazdani42/nvim-tree.lua",
			requires = "kyazdani42/nvim-web-devicons",
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
		})

		use({
			"stevearc/aerial.nvim",
			config = function()
				local ok, aerial = pcall(require, "aerial")
				if not ok then
					vim.notify("aerial not found", vim.log.levels.WARN)
					return
				end

				aerial.setup({})
			end,
		})

		use({
			"ray-x/lsp_signature.nvim",
			config = function()
				local ok, lsp_signature = pcall(require, "lsp_signature")
				if not ok then
					vim.notify("lsp_signature not found", vim.log.levels.WARN)
					return
				end

				lsp_signature.setup({})
			end,
		})

		use({
			"simnalamburt/vim-mundo",
			config = function()
				vim.keymap.set("n", "<leader>u", ":MundoToggle<cr>")
			end,
		})

		use({
			"lewis6991/spellsitter.nvim",
			config = function()
				local ok, spellsitter = pcall(require, "spellsitter")
				if not ok then
					vim.notify("spellsitter not found", vim.log.levels.WARN)
					return
				end

				spellsitter.setup()
			end,
		})

		use({
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
		})

		use({
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
		})

		use({
			"stevearc/dressing.nvim",
			config = function()
				local ok, dressing = pcall(require, "dressing")
				if not ok then
					vim.notify("dressing not found", vim.log.levels.WARN)
					return
				end

				dressing.setup({})
			end,
		})

		use({
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
		})

		use("joshuarubin/chezmoi.vim")

		use({
			"joshuarubin/terminal.nvim",
			config = function()
				local ok, term = pcall(require, "terminal")
				if not ok then
					vim.notify("terminal not found", vim.log.levels.WARN)
					return
				end
				term.setup()
			end,
		})

		use({
			"joshuarubin/go-return.nvim",
			branch = "main",
			requires = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
			config = function()
				local ok, go_return = pcall(require, "go-return")
				if not ok then
					vim.notify("go-return not found", vim.log.levels.WARN)
					return
				end

				go_return.setup()
			end,
		})

		use({
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
		})

		use({
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
		})

		use({
			"petertriho/nvim-scrollbar",
			config = function()
				if vim.g.gonvim_running == 1 then
					return
				end

				local ok, scrollbar = pcall(require, "scrollbar")
				if not ok then
					vim.notify("scrollbar not found", vim.log.levels.WARN)
					return
				end

				scrollbar.setup({
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
			end,
		})

		use("axieax/urlview.nvim")
		use("ixru/nvim-markdown")

		use({
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
			config = function()
				vim.g.mkdp_auto_close = 0
			end,
		})

		use({
			"junegunn/goyo.vim",
			config = function()
				vim.api.nvim_create_autocmd("User", {
					desc = "When starting goyo...",
					pattern = "GoyoEnter",
					nested = true,
					callback = function()
						vim.w.goyospell = vim.wo.spell
						vim.wo.spell = false
						vim.cmd("ScrollbarHide")
						vim.diagnostic.disable()
						vim.cmd("Gitsigns toggle_signs")
					end,
				})

				vim.api.nvim_create_autocmd("User", {
					desc = "When leaving goyo...",
					pattern = "GoyoLeave",
					nested = true,
					callback = function()
						if vim.w.goyospell then
							vim.wo.spell = true
						end
						vim.w.gotospell = nil
						vim.cmd("ScrollbarShow")
						vim.diagnostic.enable()
						vim.cmd("Gitsigns toggle_signs")
					end,
				})
			end,
		})

		use("junegunn/limelight.vim")

		use({
			"joshuarubin/cybu.nvim",
			branch = "buf-history-order",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
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
		})

		use("ojroques/vim-oscyank")

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		max_jobs = 8,
	},
})
