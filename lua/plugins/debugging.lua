return {
	{
		"rcarriga/nvim-dap-ui",
		config = function(_, opts)
			-- override LazyVim config to prevent automatic closing of dapui on
			-- exit and terminated events
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
		end,
	},
}
