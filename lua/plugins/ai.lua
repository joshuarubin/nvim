return {
	{
		"zbirenbaum/copilot.lua",
		cond = not vim.g.vscode,
		opts = {
			panel = {
				enabled = false,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-CR>",
				},
				layout = {
					position = "bottom", -- | top | left | right
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = false,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = "<M-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				yaml = false,
				markdown = true,
				help = true,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = "node", -- Node.js version must be > 18.x
		},
	},
	{
		"olimorris/codecompanion.nvim",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "anthropic",
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
							},
						},
						["file"] = {
							opts = {
								provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
							},
						},
						["help"] = {
							opts = {
								provider = "fzf_lua", -- telescope|mini_pick|fzf_lua
							},
						},
						["symbols"] = {
							opts = {
								provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
							},
						},
					},
				},
				inline = {
					adapter = "anthropic", -- anthropic|copilot
				},
			},
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
							api_key = "ANTHROPIC_API_KEY",
						},
					})
				end,
			},
		},
		cmd = {
			"CodeCompanion",
			"CodeCompanionActions",
			"CodeCompanionChat",
		},
		keys = {
			{
				"<c-a><c-a>",
				"<cmd>CodeCompanionActions<cr>",
				mode = { "n", "v" },
				desc = "codecompanion: actions",
			},
			{
				"<localleader>a",
				"<cmd>CodeCompanionChat Toggle<cr>",
				mode = { "n", "v" },
				desc = "codecompanion: toggle chat",
			},
			{
				"ga",
				"<cmd>CodeCompanionChat Add<cr>",
				mode = "v",
				desc = "codecompanion: add to chat",
			},
		},
		init = function()
			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cabbrev cc CodeCompanion]])
		end,
	},
}
