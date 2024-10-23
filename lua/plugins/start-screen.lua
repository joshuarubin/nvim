return {
	{
		"nvimdev/dashboard-nvim",
		opts = function(_, opts)
			local index
			for i, value in ipairs(opts.config.center) do
				if value.key == "s" then
					index = i
				end
			end
			opts.config.center[index].action = 'lua require("session_manager").load_session()'
		end,
	},
}
