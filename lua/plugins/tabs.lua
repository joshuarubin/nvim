return {
	{
		"akinsho/bufferline.nvim",
		cond = not vim.g.vscode,
		branch = "main",
		opts = {
			options = {
				numbers = function(opts)
					return tostring(opts.id)
				end,
				close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
				right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
				left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
				middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
				diagnostics = "nvim_lsp",
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = "slant",
			},
		},
	},
}
