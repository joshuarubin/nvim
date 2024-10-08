return {
	{
		"ryanoasis/vim-devicons",
		cond = not vim.g.vscode,
	},
	{
		"stevearc/dressing.nvim",
		cond = not vim.g.vscode,
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		cond = not vim.g.vscode,
		main = "ibl",
		config = function()
			local ok, ibl = pcall(require, "ibl")
			if not ok then
				vim.notify("ibl not found", vim.log.levels.WARN)
				return
			end

			ibl.setup()
		end,
	},
}
