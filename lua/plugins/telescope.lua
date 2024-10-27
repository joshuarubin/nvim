return {
	{
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				layout_config = {
					prompt_position = "top",
				},
				sorting_strategy = "ascending",
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
		},
		keys = {
			{ "<leader>gs", false },
			{ "<leader>gc", false },
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
		"jvgrootveld/telescope-zoxide",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("zoxide")
		end,
		keys = {
			{
				"<leader>fz",
				function()
					require("telescope").extensions.zoxide.list()
				end,
				desc = "Zoxide",
			},
		},
	},
}
