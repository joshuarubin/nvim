return {
	{
		"akinsho/bufferline.nvim",
		opts = {
			options = {
				numbers = function(opts)
					return tostring(opts.id)
				end,
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = "slant",
			},
		},
	},
}
