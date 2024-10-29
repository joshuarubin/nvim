local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local TabBehavior = {
	Next = 1,
	Prev = -1,
}

local supertab = function(opts)
	opts = opts or {}
	opts.behavior = opts.behavior or TabBehavior.Next

	local cmp = require("cmp")

	return cmp.mapping(function(fallback)
		if cmp.visible() and opts.behavior == TabBehavior.Next then
			cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
			return
		end

		if cmp.visible() and opts.behavior == TabBehavior.Prev then
			cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
			return
		end

		if vim.snippet.active({ direction = opts.behavior }) then
			vim.schedule(function()
				vim.snippet.jump(opts.behavior)
			end)
			return
		end

		if opts.behavior == TabBehavior.Next and has_words_before() then
			cmp.complete()
			return
		end

		fallback()
	end, { "i", "s" })
end

return {
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")
			local copilot_cmp_comparators = require("copilot_cmp.comparators")

			opts.completion = {
				completeopt = "menu,menuone,noinsert,noselect",
			}

			opts.preselect = cmp.PreselectMode.None

			require("luasnp").setup()
			table.insert(opts.sources, { name = "luasnp" })

			opts.formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					item.menu = ({
						copilot = "",
						luasnp = "",
						snippets = "",
						nvim_lsp = "",
						nvim_lua = "",
						buffer = "",
						path = "",
						emoji = "󰞅",
						calc = "",
					})[entry.source.name]

					local icons = LazyVim.config.icons.kinds
					if icons[item.kind] then
						item.kind = icons[item.kind] .. item.kind
					end

					local widths = {
						abbr = 50,
						menu = 50,
					}

					for key, width in pairs(widths) do
						if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
							item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
						end
					end

					return item
				end,
			}

			local defaults = require("cmp.config.default")()
			opts.sorting = vim.deepcopy(defaults.sorting)
			if opts.sorting then
				table.insert(opts.sorting.comparators, 1, copilot_cmp_comparators.prioritize)
			end

			opts.mapping = {
				["<c-d>"] = cmp.mapping.scroll_docs(-4),
				["<c-f>"] = cmp.mapping.scroll_docs(4),
				["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<c-space>"] = cmp.mapping.complete(),
				["<cr>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
				["<s-cr>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
				["<c-cr>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
				["<c-y>"] = LazyVim.cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
				["<c-e>"] = cmp.mapping.abort(),
				["<tab>"] = supertab(),
				["<s-tab>"] = supertab({ behavior = TabBehavior.Prev }),
			}

			return opts
		end,
	},
}
