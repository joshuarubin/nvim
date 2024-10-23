return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
		opts = {
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--with-filename",
					"--no-heading",
					"--line-number",
					"--column",
					"--hidden",
					"--smart-case",
					"--follow",
					"--color=never",
				},
				layout_config = {
					prompt_position = "top",
				},
				sorting_strategy = "ascending",
				set_env = { ["COLORTERM"] = "truecolor" },

				mappings = {
					i = {
						["<esc>"] = require("telescope.actions").close,
						["<c-j>"] = require("telescope.actions").move_selection_next,
						["<c-k>"] = require("telescope.actions").move_selection_previous,
					},

					n = {
						["<c-j>"] = require("telescope.actions").move_selection_next,
						["<c-k>"] = require("telescope.actions").move_selection_previous,
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
				},
			},
		},
		keys = {
			{ "<leader>gs", false },
			{
				"<c-b>",
				"<leader>,",
				mode = { "n" },
				remap = true,
				desc = "Switch Buffer",
			},
			{
				"<c-p>",
				"<leader><space>",
				mode = { "n" },
				remap = true,
				desc = "Find Files (Root Dir)",
			},
			{
				"<c-f>",
				"<leader>fr",
				mode = { "n" },
				remap = true,
				desc = "Recent",
			},
			{
				"<c-s><c-s>",
				"<leader>sw",
				mode = { "n" },
				remap = true,
				desc = "Word (Root Dir)",
			},
			{
				"<c-s><c-s>",
				"<leader>sw",
				mode = { "v" },
				remap = true,
				desc = "Selection (Root Dir)",
			},
			{
				"<c-s><c-d>",
				"<leader>sg",
				mode = { "n" },
				remap = true,
				desc = "Grep (Root Dir)",
			},
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		build = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"jvgrootveld/telescope-zoxide",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("zoxide")
		end,
		keys = {
			{
				"<leader>sz",
				function()
					require("telescope").extensions.zoxide.list()
				end,
				desc = "Zoxide",
			},
		},
	},
}
