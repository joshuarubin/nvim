return {
	{
		"kevinhwang91/nvim-hlslens",
		cond = not vim.g.vscode,
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
				silent = true,
			},
			{
				"N",
				"<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
				silent = true,
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
				desc = "like '*' but don't limit to whole word matches",
			},
			{
				"g#",
				"g#<cmd>lua require('hlslens').start()<cr>",
				desc = "like '#' but don't limit to whole word matches",
			},
		},
	},
}
