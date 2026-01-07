-- Register copilot as self-managed so util.lsp doesn't try to restart it
local lsp_util = require("util.lsp")

lsp_util.register_self_managed("copilot")

local copilot_group = vim.api.nvim_create_augroup("CopilotAutoTriggerGuard", {})

-- Update auto_trigger per-buffer based on disabled state to avoid notification spam
vim.api.nvim_create_autocmd("InsertEnter", {
	group = copilot_group,
	callback = function()
		vim.b.copilot_suggestion_auto_trigger = not require("copilot.client").is_disabled()
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = copilot_group,
	pattern = { "LspStopPre", "LspRestartPre" },
	callback = lsp_util.on_client("copilot", function()
		require("copilot.command").disable()
	end),
})

-- Re-enable Copilot after LSP start/restart
vim.api.nvim_create_autocmd("User", {
	group = copilot_group,
	pattern = { "LspStartPost", "LspRestartPost" },
	callback = lsp_util.on_client("copilot", function()
		vim.b.copilot_suggestion_auto_trigger = true
		require("copilot.command").enable()
	end),
})

return {
	{
		"zbirenbaum/copilot.lua",
		cond = not vim.g.vscode,
		enabled = true,
		opts = {
			panel = {
				enabled = false,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<cr>",
					refresh = "gr",
					open = "<m-cr>",
				},
				layout = {
					position = "bottom", -- | top | left | right
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = "<c-e>",
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
