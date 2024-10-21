return {
	{
		"folke/lazy.nvim",
		version = false,
	},
	{
		"LazyVim/LazyVim",
		version = false,
		opts = {
			colorscheme = "gruvbox",
			news = {
				lazyvim = false,
				neovim = false,
			},
		},
	},
	"tpope/vim-surround", -- quoting/parenthesizing made simple
	"tpope/vim-repeat", -- enable repeating supported plugin maps with `.`
	"tpope/vim-eunuch", -- helpers for unix
	"tpope/vim-abolish", -- easily search for, substitute, and abbreviate multiple variants of a word

	{
		"direnv/direnv.vim",
		cond = not vim.g.vscode,
	},
}
