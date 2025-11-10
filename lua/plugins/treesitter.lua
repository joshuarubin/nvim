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
					-- ["]c"] = nil,
				},
				goto_next_end = {
					["]["] = "@function.outer",
					["]M"] = "@class.outer",
					-- ["]C"] = nil,
				},
				goto_previous_start = {
					["[["] = "@function.outer",
					["[m"] = "@class.outer",
					-- ["]c"] = nil,
				},
				goto_previous_end = {
					["[]"] = "@function.outer",
					["[M"] = "@class.outer",
					-- ["]C"] = nil,
				},
			}
			local ret = {} ---@type LazyKeysSpec[]
			for method, keymaps in pairs(moves) do
				for key, query in pairs(keymaps) do
					local desc = query:gsub("@", ""):gsub("%..*", "")
					desc = desc:sub(1, 1):upper() .. desc:sub(2)
					desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
					desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
					ret[#ret + 1] = {
						key,
						function()
							-- don't use treesitter if in diff mode and the key is one of the c/C keys
							if vim.wo.diff and key:find("[cC]") then
								return vim.cmd("normal! " .. key)
							end
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
