--[[
colorscheme.lua - Color Schemes with Lazy-Loading

Plugins:
- tokyonight.nvim: Default theme (loaded immediately)
- gruvbox.nvim, kanagawa.nvim, rose-pine, dracula.nvim, cyberdream.nvim,
  sonokai, solarized-osaka.nvim, nordic.nvim, bamboo.nvim, gruvbox-material,
  monokai-pro.nvim, catppuccin: Alternative themes (lazy-loaded on demand)

Organization rule: All color schemes grouped together
Lazy-loading strategy: Only the default theme loads at startup. All others
load only when selected via :colorscheme command. This significantly improves
startup time while keeping all themes available.

See: lua/plugins/init.lua for placement guidelines
--]]

return {
	-- Default color scheme - loads immediately at startup
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

	-- Alternative color schemes below are lazy-loaded on demand
	-- They only load when you run :colorscheme <name>

	{
		"ellisonleao/gruvbox.nvim",
		cond = not vim.g.vscode,
		lazy = true,
		config = true,
	},
	{
		"rebelot/kanagawa.nvim",
		cond = not vim.g.vscode,
		lazy = true,
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
		lazy = true,
	},
	{
		"Mofiqul/dracula.nvim",
		cond = not vim.g.vscode,
		lazy = true,
		opts = {
			italic_comment = true,
		},
	},
	{
		"scottmckendry/cyberdream.nvim",
		cond = not vim.g.vscode,
		lazy = true,
		opts = {
			transparent = true,
			italic_comments = true,
		},
	},
	{
		"sainnhe/sonokai",
		cond = not vim.g.vscode,
		lazy = true,
		init = function()
			vim.g.sonokai_enable_italic = true
		end,
	},
	{
		"craftzdog/solarized-osaka.nvim",
		cond = not vim.g.vscode,
		lazy = true,
		opts = {},
	},
	{
		"AlexvZyl/nordic.nvim",
		cond = not vim.g.vscode,
		lazy = true,
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
		lazy = true,
		opts = {},
	},
	{
		"sainnhe/gruvbox-material",
		cond = not vim.g.vscode,
		lazy = true,
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
		lazy = true,
		opts = {},
	},
	{
		"catppuccin/nvim",
		cond = not vim.g.vscode,
		name = "catppuccin",
		lazy = true,
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
