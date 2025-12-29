return {
	{
		"folke/lazy.nvim",
		version = false,
	},
	{
		"LazyVim/LazyVim",
		version = false,
		opts = {
			colorscheme = "tokyonight",
			news = {
				lazyvim = false,
				neovim = false,
			},
			icons = {
				kinds = {
					Snippet = " ",
				},
			},
		},
	},
	{
		"gbprod/yanky.nvim",
		keys = {
			{ "p", "<Plug>(YankyPutBefore)", mode = { "x" }, desc = "Put Text Before Cursor" },
		},
	},
	{
		"mistweaverco/kulala.nvim",
		opts = {
			contenttypes = {
				-- this is just copied from the default application/json
				["application/problem+json"] = {
					ft = "json",
					formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
					pathresolver = function(...)
						return require("kulala.parser.jsonpath").parse(...)
					end,
				},
			},
		},
	},
	{
		"tpope/vim-eunuch", -- helpers for unix
		cmd = {
			"Cfind",
			"Chmod",
			"Clocate",
			"Copy",
			"Delete",
			"Duplicate",
			"Lfind",
			"Llocate",
			"Mkdir",
			"Remove",
			"SudoEdit",
			"SudoWrite",
			"Unlink",
			"W",
			"Wall",
		},
		event = {
			"BufNewFile",
			"BufReadPost",
		},
		config = function()
			vim.api.nvim_create_user_command("Move", function()
				Snacks.rename.rename_file()
			end, { desc = "Move File" })

			vim.api.nvim_create_user_command("Rename", function()
				Snacks.rename.rename_file()
			end, { desc = "Rename File" })
		end,
	},
	{
		"direnv/direnv.vim",
		init = function()
			vim.g.direnv_silent_load = 1
		end,
	},
	{
		"nvim-mini/mini.pairs",
		cond = not vim.g.vscode,
		opts = {
			modes = {
				command = false,
			},
		},
	},
	{
		"monaqa/dial.nvim",
		keys = {
			{
				"+",
				function()
					require("dial.map").manipulate("increment", "normal")
				end,
				desc = "Increment",
			},
			{
				"=",
				"+",
				desc = "Increment",
				remap = true,
			},
			{
				"-",
				function()
					require("dial.map").manipulate("decrement", "normal")
				end,
				desc = "Decrement",
			},
			{ "<c-a>", false, mode = { "n", "v" } },
			{ "<c-x>", false, mode = { "n", "v" } },
			{ "g<c-a>", false, mode = { "n", "v" } },
			{ "g<c-x>", false, mode = { "n", "v" } },
		},
	},
	{
		"julienvincent/hunk.nvim",
		cmd = { "DiffEditor" },
		opts = {
			keys = {
				global = {
					quit = { "q" },
					accept = { "<leader><cr>" },
					focus_tree = { "<leader>e" },
				},

				tree = {
					expand_node = { "l", "<right>" },
					collapse_node = { "h", "<left>" },
					open_file = { "<cr>" },
					toggle_file = { "a" },
				},

				diff = {
					toggle_line = { "a" },
					toggle_hunk = { "A" },
				},
			},

			ui = {
				tree = {
					mode = "nested",
					width = 35,
				},
				layout = "vertical",
			},
		},
	},
	{
		"Dzordzu/vim-cedar",
	},
	{
		"willothy/flatten.nvim",
		-- Ensure that it runs first to minimize delay when opening file from terminal
		enabled = false,
		lazy = false,
		priority = 1001,
		opts = function()
			local saved_terminal
			return {
				nest_if_no_args = true, -- fix jj split
				window = {
					-- this is the same as "vsplit" with focus == "first", however
					-- if the calling buffer is a terminal, the vsplit is made
					-- relative to the previous window
					open = function(opts)
						local focus = opts.files[1]
						local win = 0
						if vim.bo.buftype == "terminal" then
							-- use previous window
							win = vim.fn.win_getid(vim.fn.winnr("#"))
						end
						local winnr = vim.api.nvim_open_win(focus.bufnr, true, {
							vertical = true,
							win = win,
						})
						return focus.bufnr, winnr
					end,
				},
				hooks = {
					pre_open = function(opts)
						local win = vim.api.nvim_get_current_win()
						local buf = vim.api.nvim_win_get_buf(win)

						for _, term in ipairs(Snacks.terminal.list()) do
							if term.closed == false and term.buf == buf and term.win == win then
								saved_terminal = term
								break
							end
						end
						return require("flatten").hooks.pre_open(opts)
					end,
					post_open = function(opts)
						if opts.is_blocking and saved_terminal then
							-- hide the terminal while it's blocking
							saved_terminal:toggle()
						end
						return require("flatten").hooks.post_open(opts)
					end,
					block_end = function(opts)
						-- after blocking ends (for a git commit, etc), reopen the terminal
						vim.schedule(function()
							if saved_terminal then
								saved_terminal:toggle()
								saved_terminal = nil
							end
						end)
						return require("flatten").hooks.block_end(opts)
					end,
				},
			}
		end,
	},
	{
		"joshuarubin/terminal.nvim",
		cond = not vim.g.vscode,
		opts = {},
	},
	{
		"simnalamburt/vim-mundo",
		cond = not vim.g.vscode,
		keys = { {
			"<leader>uu",
			":MundoToggle<cr>",
			silent = true,
			desc = "Undo Tree",
		} },
	},
	{
		"nvim-lualine/lualine.nvim",
		cond = not vim.g.vscode,
		opts = {
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
		},
	},
	{
		"folke/snacks.nvim",
		opts = {
			terminal = {
				-- this is needed for terminal.nvim to work
				interactive = false,
			},
			words = {
				enabled = false,
			},
			styles = {
				terminal = {
					keys = {
						q = "<nop>",
						term_normal = "<nop>",
					},
				},
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "norg", "rmd", "org", "Avante", "codecompanion" },
		cond = not vim.g.vscode,
		opts = {
			render_modes = { "n", "c", "t", "i" },
			win_options = {
				conceallevel = {
					default = 3,
					rendered = 3,
				},
				concealcursor = {
					rendered = "",
				},
			},
		},
	},
	{
		"ibhagwan/fzf-lua",
		cond = not vim.g.vscode,
		keys = {
			{ "<leader>fc", false },
			{ "<leader>gs", false },
			{ "<leader>gc", false },
		},
	},
	{
		"swaits/lazyjj.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			mapping = "<leader>jj",
		},
	},
}
