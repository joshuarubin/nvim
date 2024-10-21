return {
	{
		"nvim-telescope/telescope.nvim",
		cond = not vim.g.vscode,
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
			{
				"<c-b>",
				require("telescope.builtin").buffers,
				mode = { "n", "t" },
				desc = "buffers (telescope)",
			},
			{
				"gd",
				require("telescope.builtin").lsp_definitions,
				desc = "lsp definitions (telescope)",
			},
			{
				"gi",
				require("telescope.builtin").lsp_implementations,
				desc = "lsp implementations (telescope)",
			},
			{
				"gy",
				require("telescope.builtin").lsp_type_definitions,
				desc = "lsp type definitions (telescope)",
			},
			{
				"gr",
				require("telescope.builtin").lsp_references,
				desc = "lsp references (telescope)",
			},
			{ "<leader>gs", false },
			{
				"<leader>y",
				require("telescope.builtin").lsp_document_symbols,
				desc = "lsp document symbols (telescope)",
			},
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		cond = not vim.g.vscode,
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
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("zoxide")
		end,
		keys = {
			{
				"<leader>z",
				function()
					require("telescope").extensions.zoxide.list()
				end,
				desc = "zoxide list (telescope)",
			},
		},
	},
	{
		"joshuarubin/rubix-telescope.nvim",
		cond = not vim.g.vscode,
		dependencies = {
			"joshuarubin/rubix.vim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("rubix")
		end,
		keys = {
			{
				"<c-p>",
				function()
					require("telescope").extensions.rubix.find_files()
				end,
				mode = { "n", "t" },
				desc = "find files (telescope)",
			},
			{
				"<c-f>",
				function()
					require("telescope").extensions.rubix.history()
				end,
				desc = "file history (telescope)",
			},
			{
				"<c-s><c-s>",
				function()
					require("telescope").extensions.rubix.grep_string()
				end,
				desc = "grep for string under cursor (telescope)",
			},
			{
				"<c-s><c-d>",
				function()
					require("telescope").extensions.rubix.live_grep()
				end,
				desc = "live grep (telescope)",
			},
		},
	},
}
