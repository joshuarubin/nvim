return {
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
	{
		"nvim-mini/mini.icons",
		cond = not vim.g.vscode,
		opts = {
			filetype = {
				go = {
					glyph = "",
				},
			},
		},
	},
}
