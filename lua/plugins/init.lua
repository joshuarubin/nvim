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
	"direnv/direnv.vim",
	{
		"monaqa/dial.nvim",
		keys = {
			{
				"+",
				function()
					require("dial.map").manipulate("increment", "normal")
				end,
				desc = "Increment",
			},
			{
				"=",
				"+",
				desc = "Increment",
				remap = true,
			},
			{
				"-",
				function()
					require("dial.map").manipulate("decrement", "normal")
				end,
				desc = "Decrement",
			},
			{ "<c-a>", false, mode = { "n", "v" } },
			{ "<c-x>", false, mode = { "n", "v" } },
			{ "g<c-a>", false, mode = { "n", "v" } },
			{ "g<c-x>", false, mode = { "n", "v" } },
		},
	},
}
