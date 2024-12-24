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
			"hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
			{ "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
		},
		opts = {
			display = {
				chat = {
					render_headers = false,
				},
			},
			strategies = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					-- adapter = "copilot",
					adapter = "anthropic",
				},
			},
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
							api_key = "ANTHROPIC_API_KEY",
						},
						-- schema = {
						-- 	model = {
						-- 		default = "claude-3-opus-20240229",
						-- 	},
						-- },
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
			-- {
			-- 	"<localleader>a",
			-- 	"",
			-- 	desc = "+ai",
			-- 	mode = { "n", "v" },
			-- },
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
