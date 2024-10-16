local open_mapping = "<c-x>"

return {
	{
		"joshuarubin/terminal.nvim",
		cond = not vim.g.vscode,
		opts = {},
	},
	{
		"akinsho/toggleterm.nvim",
		cond = not vim.g.vscode,
		branch = "main",
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return 80
				end
			end,
			shade_terminals = false,
			open_mapping = open_mapping,
			start_in_insert = false,
			direction = "horizontal", -- "vertical" | "horizontal" | "window" | "float"
			float_opts = {
				border = "single", -- "single" | "double" | "shadow" | "curved"
				winblend = 20,
			},
			on_open = function()
				vim.defer_fn(function()
					require("barbecue.ui").update()
				end, 0)
			end,
		},
		keys = {
			{ open_mapping, desc = "open terminal" },
			{
				"<leader>gg",
				function()
					if vim.fn.executable("lazygit") == 0 then
						vim.notify("lazygit not found", vim.log.levels.WARN)
						return
					end
					require("toggleterm.terminal").Terminal
						:new({
							cmd = "lazygit",
							dir = vim.fn.expand("%:p:h"),
							direction = "float",
							float_opts = {
								winblend = 0,
							},
						})
						:toggle()
				end,
				desc = "lazygit",
			},
		},
	},
}
