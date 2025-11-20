return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"cue",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		opts = function(_, opts)
			-- Remove ]c and [c from LazyVim's defaults to avoid conflicts with gitsigns
			-- and add custom function/class navigation mappings
			if opts.move and opts.move.keys then
				if opts.move.keys.goto_next_start then
					opts.move.keys.goto_next_start["]c"] = nil
					opts.move.keys.goto_next_start["]]"] = "@function.outer"
					opts.move.keys.goto_next_start["]m"] = "@class.outer"
				end
				if opts.move.keys.goto_next_end then
					opts.move.keys.goto_next_end["]["] = "@function.outer"
					opts.move.keys.goto_next_end["]M"] = "@class.outer"
				end
				if opts.move.keys.goto_previous_start then
					opts.move.keys.goto_previous_start["[c"] = nil
					opts.move.keys.goto_previous_start["[["] = "@function.outer"
					opts.move.keys.goto_previous_start["[m"] = "@class.outer"
				end
				if opts.move.keys.goto_previous_end then
					opts.move.keys.goto_previous_end["[]"] = "@function.outer"
					opts.move.keys.goto_previous_end["[M"] = "@class.outer"
				end
			end
			return opts
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
}
