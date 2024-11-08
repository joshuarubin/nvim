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

local get_prev_word = function()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	if col == 0 then
		return nil
	end

	-- move the cursor back one char so that the cursor is actually on a word
	vim.api.nvim_win_set_cursor(0, { row, col - 1 })

	-- this is so much simpler than trying to parse the line
	local word = vim.fn.expand("<cWORD>")

	-- and return the cursor to where it was
	vim.api.nvim_win_set_cursor(0, { row, col })

	return word, { row, col }
end

-- this only works for my own luasnp source
local expand_snippet = function()
	local snippets = require("luasnp.snippets")
	local context = require("cmp.context")

	local label, pos = get_prev_word()
	if not label or not pos then
		return false
	end

	local snip = snippets.get_exact(label, context.new())
	if not snip then
		return false
	end

	-- remove the label from the buffer
	local row, col = unpack(pos)
	local start_col = math.max(col - #label, 0)
	vim.api.nvim_buf_set_text(0, row - 1, start_col, row - 1, col, {})

	vim.snippet.expand(snip)

	return true
end

local expand_snippet_with_fallback = function(fallback)
	if not expand_snippet() then
		fallback()
	end
end

local confirm = function(opts, fallback)
	local lazyConfirm = LazyVim.cmp.confirm(opts)
	return function(f)
		lazyConfirm(function()
			fallback(f)
		end)
	end
end

return {
	{
		"hrsh7th/nvim-cmp",
		cond = not vim.g.vscode,
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
						copilot = " ",
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

			opts.experimental.ghost_text = false

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
				["<cr>"] = confirm(
					{ select = false, behavior = cmp.ConfirmBehavior.Replace },
					expand_snippet_with_fallback
				),
				["<s-cr>"] = confirm(
					{ select = false, behavior = cmp.ConfirmBehavior.Replace },
					expand_snippet_with_fallback
				),
				["<c-cr>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
				["<c-y>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
				["<c-e>"] = cmp.mapping.abort(),
				["<tab>"] = supertab(),
				["<s-tab>"] = supertab({ behavior = TabBehavior.Prev }),
			}

			return opts
		end,
	},
}
