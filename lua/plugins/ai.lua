return {
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = false,
				drag_and_drop = {
					insert_mode = true,
				},
			},
		},
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		build = "make",
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"zbirenbaum/copilot.lua",
			"HakonHarnes/img-clip.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		keys = function(_, keys)
			local opts = require("lazy.core.plugin").values(
				require("lazy.core.config").spec.plugins["avante.nvim"],
				"opts",
				false
			)

			local ok, avante_api = pcall(require, "avante.api")
			if not ok then
				vim.notify("avante not found", vim.log.levels.WARN)
				return
			end

			local mappings = {
				{
					opts.mappings.group,
					"",
					desc = "+ai",
					mode = { "n", "v" },
				},
				{
					opts.mappings.ask,
					function()
						avante_api.ask()
					end,
					desc = "avante: ask",
					mode = { "n", "v" },
				},
				{
					opts.mappings.refresh,
					function()
						avante_api.refresh()
					end,
					desc = "avante: refresh",
					mode = "v",
				},
				{
					opts.mappings.edit,
					function()
						avante_api.edit()
					end,
					desc = "avante: edit",
					mode = { "n", "v" },
				},
			}

			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)

			return vim.list_extend(mappings, keys)
		end,
		opts = {
			--- "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot"
			provider = "claude", -- Recommend using Claude
			-- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
			auto_suggestions_provider = "claude",
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-5-sonnet-20240620",
				-- model = "claude-3-opus-20240229",
				temperature = 0,
				max_tokens = 4096,
			},
			behaviour = {
				auto_suggestions = false, -- Experimental stage
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
			},
			mappings = {
				group = "<leader>a",
				ask = "<leader>aa", -- ask
				edit = "<leader>ae", -- edit
				refresh = "<leader>ar", -- refresh
				diff = {
					ours = "co",
					theirs = "ct",
					all_theirs = "ca",
					both = "cb",
					cursor = "cc",
					next = "]x",
					prev = "[x",
				},
				suggestion = {
					accept = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
				jump = {
					next = "]]",
					prev = "[[",
				},
				submit = {
					normal = "<CR>",
					insert = "<C-s>",
				},
			},
			hints = { enabled = true },
			windows = {
				position = "right", -- the position of the sidebar
				wrap = true, -- similar to vim.o.wrap
				width = 30, -- default % based on available width
				sidebar_header = {
					align = "center", -- left, center, right for title
					rounded = true,
				},
			},
			highlights = {
				diff = {
					current = "DiffText",
					incoming = "DiffAdd",
				},
			},
			diff = {
				autojump = true,
				list_opener = "copen",
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
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
}
