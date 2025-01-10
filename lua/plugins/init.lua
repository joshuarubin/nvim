return {
	{
		"folke/lazy.nvim",
		version = false,
	},
	{
		"LazyVim/LazyVim",
		version = false,
		opts = {
			colorscheme = "tokyonight",
			news = {
				lazyvim = false,
				neovim = false,
			},
			icons = {
				kinds = {
					Snippet = " ",
				},
			},
		},
	},
	{
		"tpope/vim-eunuch", -- helpers for unix
		cmd = {
			"Cfind",
			"Chmod",
			"Clocate",
			"Copy",
			"Delete",
			"Duplicate",
			"Lfind",
			"Llocate",
			"Mkdir",
			"Remove",
			"SudoEdit",
			"SudoWrite",
			"Unlink",
			"W",
			"Wall",
		},
		event = {
			"BufNewFile",
			"BufReadPost",
		},
		config = function()
			vim.api.nvim_create_user_command("Move", function()
				Snacks.rename.rename_file()
			end, { desc = "Move File" })

			vim.api.nvim_create_user_command("Rename", function()
				Snacks.rename.rename_file()
			end, { desc = "Rename File" })
		end,
	},
	"direnv/direnv.vim",
	{
		"echasnovski/mini.pairs",
		cond = not vim.g.vscode,
		opts = {
			modes = {
				command = false,
			},
		},
	},
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
