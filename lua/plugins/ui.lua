--[[
ui.lua - User Interface and Visual Enhancements

Plugins:
- edgy.nvim: Window layout and sidebar management
- noice.nvim: Enhanced UI for messages, cmdline, and popups (disabled)
- mini.icons: Icon provider for file types and UI elements
- lualine.nvim: Statusline with theme integration
- snacks.nvim: Collection of small UI utilities
- render-markdown.nvim: Live markdown rendering in buffers
- flatten.nvim: Nested nvim instance management (disabled)

Organization rule: All UI/visual/display plugins grouped together
See: lua/plugins/init.lua for placement guidelines
--]]

return {
	-- Window layout and sidebar management
	{
		"folke/edgy.nvim",
		cond = not vim.g.vscode,
		opts = {
			animate = {
				enabled = false,
			},
			options = {
				left = { size = 40 },
				right = { size = 40 },
			},
			keys = {
				-- increase width
				["<c-a>L"] = function(win)
					win:resize("width", 1)
				end,
				-- decrease width
				["<c-a>H"] = function(win)
					win:resize("width", -1)
				end,
				-- increase height
				["<c-a>K"] = function(win)
					win:resize("height", 1)
				end,
				-- decrease height
				["<c-a>J"] = function(win)
					win:resize("height", -1)
				end,
				-- increase width
				["<d-l>"] = function(win)
					win:resize("width", 1)
				end,
				-- decrease width
				["<d-h>"] = function(win)
					win:resize("width", -1)
				end,
				-- increase height
				["<d-k>"] = function(win)
					win:resize("height", 1)
				end,
				-- decrease height
				["<d-j>"] = function(win)
					win:resize("height", -1)
				end,
			},
		},
	},

	-- Enhanced UI for messages, cmdline, and popups (currently disabled)
	{
		"folke/noice.nvim",
		cond = not vim.g.vscode,
		enabled = false,
		opts = {
			cmdline = {
				view = "cmdline",
			},
			presets = {
				command_palette = false,
				lsp_doc_border = true,
				inc_rename = false,
			},
		},
		keys = {
			{ "<c-b>", false },
			{ "<c-f>", false },
		},
	},

	-- Icon provider for file types and UI elements
	{
		"nvim-mini/mini.icons",
		cond = not vim.g.vscode,
		opts = {
			filetype = {
				go = {
					glyph = "",
				},
			},
		},
	},

	-- Statusline with automatic theme integration
	{
		"nvim-lualine/lualine.nvim",
		cond = not vim.g.vscode,
		opts = {
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
		},
	},

	-- Collection of small UI utilities
	{
		"folke/snacks.nvim",
		keys = {
			{
				"<leader>.",
				function()
					Snacks.scratch({ ft = "markdown" })
				end,
				desc = "Markdown Scratch Buffer",
			},
			{
				"<leader>s.",
				function()
					Snacks.scratch()
				end,
				desc = "Scratch Buffer (inherit filetype)",
			},
		},
		opts = {
			picker = {
				actions = {
					scratch_delete = function(picker, item)
						local file = item.file
						-- Find and delete the buffer if it exists
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == file then
								vim.api.nvim_buf_delete(buf, { force = true })
								break
							end
						end
						-- Delete files
						os.remove(file)
						os.remove(file .. ".meta")
						picker:refresh()
					end,
				},
			},
			scratch = {
				autowrite = true, -- Auto-save when switching buffers
				win = {
					wo = {
						spell = false,
					},
					keys = {
						["delete"] = {
							"<c-x>",
							function(self)
								local file = vim.api.nvim_buf_get_name(self.buf)
								local buf = self.buf
								local filename = vim.fn.fnamemodify(file, ":t")

								-- Close window first
								vim.api.nvim_win_call(self.win, function()
									vim.cmd("close")
								end)

								-- Confirm before deletion
								vim.ui.select({ "No", "Yes" }, {
									prompt = string.format("Delete '%s'?", filename),
									format_item = function(item)
										return item
									end,
								}, function(choice)
									if choice == "Yes" then
										os.remove(file)
										os.remove(file .. ".meta")
										vim.api.nvim_buf_delete(buf, { force = true })
									end
								end)
							end,
							desc = "Delete scratch buffer",
						},
					},
				},
			},
			terminal = {
				-- Disable interactive mode to work with terminal.nvim
				interactive = false,
			},
			words = {
				-- Disable word highlighting feature
				enabled = false,
			},
			styles = {
				terminal = {
					keys = {
						-- Disable default terminal keybindings
						q = "<nop>",
						term_normal = "<nop>",
					},
				},
			},
		},
	},

	-- Live markdown rendering with concealment
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "norg", "rmd", "org", "Avante", "codecompanion" },
		cond = not vim.g.vscode,
		opts = {
			-- Render in all modes including insert
			render_modes = { "n", "c", "t", "i" },
			-- Disable anti_conceal, use concealcursor instead
			anti_conceal = {
				enabled = false,
			},
			win_options = {
				conceallevel = {
					default = 3,
					rendered = 3,
				},
				concealcursor = {
					-- Conceal cursor line in normal/visual/command, reveal in insert
					rendered = "nvc",
				},
				spell = {
					default = false,
					rendered = false,
				},
			},
		},
	},

	-- Nested nvim instance management for terminal workflows (currently disabled)
	-- Handles opening files from terminal instances with smart window management
	{
		"willothy/flatten.nvim",
		enabled = false,
		lazy = false,
		priority = 1001, -- Load first to minimize delay when opening from terminal
		opts = function()
			local saved_terminal
			return {
				-- Fix jj split workflow by nesting when no args
				nest_if_no_args = true,
				window = {
					-- Custom window opening logic relative to calling terminal
					-- Same as "vsplit" with focus == "first", but if calling buffer
					-- is a terminal, vsplit is made relative to previous window
					open = function(opts)
						local focus = opts.files[1]
						local win = 0
						if vim.bo.buftype == "terminal" then
							-- Use previous window instead of terminal window
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
					-- Pre-open hook: Save terminal state before opening file
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
					-- Post-open hook: Hide terminal while blocking operation active
					post_open = function(opts)
						if opts.is_blocking and saved_terminal then
							saved_terminal:toggle()
						end
						return require("flatten").hooks.post_open(opts)
					end,
					-- Block-end hook: Restore terminal after blocking operation
					block_end = function(opts)
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
}
