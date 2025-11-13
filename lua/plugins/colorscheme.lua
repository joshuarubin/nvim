return {
	{
		"folke/tokyonight.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		opts = {
			on_highlights = function(hl, c)
				-- Make window separators more visible
				hl.WinSeparator = { fg = "#545c7e" }
				hl.VertSplit = { fg = "#545c7e" }
			end,
		},
	},
	{
		"ellisonleao/gruvbox.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		config = true,
	},
	{
		"rebelot/kanagawa.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		opts = {
			dimInactive = false,
			terminalColors = true,
			background = {
				dark = "wave",
				light = "lotus",
			},
		},
	},
	{
		"rose-pine/neovim",
		cond = not vim.g.vscode,
		name = "rose-pine",
		lazy = false,
		priority = 1000,
	},
	{
		"Mofiqul/dracula.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		opts = {
			italic_comment = true,
		},
	},
	{
		"scottmckendry/cyberdream.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			italic_comments = true,
		},
	},
	{
		"sainnhe/sonokai",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		init = function()
			vim.g.sonokai_enable_italic = true
		end,
	},
	{
		"craftzdog/solarized-osaka.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"AlexvZyl/nordic.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		opts = {
			transparent = {
				bg = true,
			},
			reduced_blue = false,
		},
	},
	{

		"ribru17/bamboo.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"sainnhe/gruvbox-material",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		init = function()
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_material_current_word = "underline"
			vim.g.gruvbox_material_inlay_hints_background = "dimmed"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "original"
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_statusline_style = "original"
			vim.g.gruvbox_material_diagnostic_text_highlight = 1
			vim.g.gruvbox_material_diagnostic_virtual_text = "highlighted"
		end,
	},
	{
		"loctvl842/monokai-pro.nvim",
		cond = not vim.g.vscode,
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"catppuccin/nvim",
		cond = not vim.g.vscode,
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			integrations = {
				barbecue = {
					alt_background = true,
				},
			},
		},
	},
}
