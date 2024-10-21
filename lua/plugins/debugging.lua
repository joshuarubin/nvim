return {
	{
		"rcarriga/nvim-dap-ui",
		cond = not vim.g.vscode,
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
		end,
	},
	{
		"leoluz/nvim-dap-go",
		cond = not vim.g.vscode,
		config = true,
		keys = {
			{
				"<leader>td",
				function()
					require("dap-go").debug_test()
				end,
				desc = "Debug Go test",
			},
			{
				"<leader>tl",
				function()
					require("dap-go").debug_last_test()
				end,
				desc = "Debug Last Go test",
			},
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		cond = not vim.g.vscode,
		opts = {
			ensure_installed = {
				"delve",
			},
		},
	},
}
