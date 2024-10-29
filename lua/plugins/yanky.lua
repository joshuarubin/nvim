return {
	{
		"gbprod/yanky.nvim",
		opts = {
			picker = {
				telescope = {
					use_default_mappings = false,
				},
			},
		},
		config = function(_, opts)
			local mapping = require("yanky.telescope.mapping")
			local utils = require("yanky.utils")

			opts.picker.telescope.mappings = {
				default = mapping.put("p"),
				i = {
					["<c-g>"] = mapping.put("p"),
					["<c-x>"] = mapping.delete(),
					["<c-r>"] = mapping.set_register(utils.get_default_register()),
				},
				n = {
					p = mapping.put("p"),
					P = mapping.put("P"),
					d = mapping.delete(),
					r = mapping.set_register(utils.get_default_register()),
				},
			}

			require("yanky").setup(opts)
		end,
	},
}
