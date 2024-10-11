return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
		opts = {
			auto_install = true,
			sync_install = true,
			ensure_installed = {
				"c",
				"lua",
				"query",
				"vim",
				"vimdoc",
			},
			highlight = { enable = true },
			-- indent = { enable = true }, -- TODO(jawa) this is too experimental right now, enable when possible
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			context_commentstring = {
				enable = true,
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
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
	},
	"nvim-treesitter/nvim-treesitter-textobjects",
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
	{
		"joshuarubin/go-return.nvim",
		cond = not vim.g.vscode,
		branch = "main",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"L3MON4D3/LuaSnip",
		},
		opts = {},
	},
}
