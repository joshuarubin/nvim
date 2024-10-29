return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]]"] = "@function.outer",
						["]m"] = "@class.outer",
					},
					goto_next_end = {
						["]["] = "@function.outer",
						["]M"] = "@class.outer",
					},
					goto_previous_start = {
						["[["] = "@function.outer",
						["[m"] = "@class.outer",
					},
					goto_previous_end = {
						["[]"] = "@function.outer",
						["[M"] = "@class.outer",
					},
				},
			},
		},
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
			end

			opts.textobjects.move.goto_next_start["]c"] = nil
			opts.textobjects.move.goto_next_end["]C"] = nil
			opts.textobjects.move.goto_previous_start["[c"] = nil
			opts.textobjects.move.goto_previous_end["[C"] = nil

			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	"nvim-treesitter/nvim-treesitter-textobjects",
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
}
