return {
	{
		"Shatur/neovim-session-manager",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			autosave_last_session = true,
			autosave_only_in_session = true,
			autosave_ignore_filetypes = {
				"gitcommit",
				"gitrebase",
				"toggleterm",
			},
		},
		config = function(_, opts)
			opts.autoload_mode = {
				require("session_manager.config").AutoloadMode.GitSession,
				require("session_manager.config").AutoloadMode.CurrentDir,
			}
			require("session_manager").setup(opts)
		end,
		init = function()
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				callback = function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
							return
						end
					end
					require("session_manager").save_current_session()
				end,
			})
			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "SessionLoadPost",
				callback = function()
					require("neo-tree.command").execute({
						action = "show",
						toggle = true,
						dir = LazyVim.root(),
					})
				end,
			})
		end,
	},
}
