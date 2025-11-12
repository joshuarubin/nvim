return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"cue",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		keys = function()
			local moves = {
				goto_next_start = {
					["]]"] = "@function.outer",
					["]m"] = "@class.outer",
				},
				goto_next_end = {
					["]["] = "@function.outer",
					["]M"] = "@class.outer",
				},
				goto_previous_start = {
					["[["] = "@function.outer",
					["[m"] = "@class.outer",
				},
				goto_previous_end = {
					["[]"] = "@function.outer",
					["[M"] = "@class.outer",
				},
			}
			-- Generate lazy key specs for all treesitter text object movements
			local ret = {} ---@type LazyKeysSpec[]
			for method, keymaps in pairs(moves) do
				for key, query in pairs(keymaps) do
					-- Build description from query: "@function.outer" -> "Function"
					local desc = query:gsub("@", ""):gsub("%..*", "")
					desc = desc:sub(1, 1):upper() .. desc:sub(2)
					-- Add direction prefix: "[" = "Prev", "]" = "Next"
					desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
					-- Add position suffix: uppercase 2nd char = "End", lowercase = "Start"
					desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
					ret[#ret + 1] = {
						key,
						function()
							-- Call treesitter-textobjects navigation method
							require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
						end,
						desc = desc,
						mode = { "n", "x", "o" },
						silent = true,
					}
				end
			end
			return ret
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
}
