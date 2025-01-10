return {
	{
		"utilyre/barbecue.nvim",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			opts.show_modified = true

			if (vim.g.colors_name or ""):find("tokyonight") then
				local C = require("tokyonight.colors").setup()
				opts.theme = {
					normal = { bg = C.bg_dark },
				}
			end
		end,
	},
}
