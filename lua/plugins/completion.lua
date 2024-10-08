local function t(keys)
	return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

local cmpFallback = function(key)
	vim.fn.feedkeys(t("<c-]>")) -- complete abbreviations
	vim.fn.feedkeys(t("<c-g>u")) -- create undo point

	-- fallback to normal key
	vim.fn.feedkeys(t(key), "n") -- using fallback() breaks abbreviations

	-- telescope breaks when opening a new file in the same buffer unless we do this
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
	if filetype ~= "TelescopePrompt" then
		vim.fn.feedkeys(t("<plug>Endwise"))
	end
end

local cmpComplete = function(cmp, luasnip, fallback, key, only_selected)
	local selected = cmp.core.view:get_selected_entry()
	if selected then -- normal completion
		cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace })(fallback)
		return
	end

	local expandable = luasnip.expandable()
	if expandable then -- nothing is selected in the popup menu, but the entered text is an expandable snippet
		vim.fn.feedkeys(t("<plug>luasnip-expand-snippet"))
		return
	end

	if not only_selected then
		cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
		selected = cmp.core.view:get_selected_entry()
		if selected then
			cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace })(fallback)
			return
		end
		-- cmp.close()
		-- TODO(jrubin)
		-- return
	end

	cmp.abort() -- close cmp
	cmpFallback(key)
end

local complete = function(cmp, luasnip, fallback, key, only_selected)
	-- if the popup menu is visible
	if cmp.visible() then
		cmpComplete(cmp, luasnip, fallback, key, only_selected)
		return
	end

	local expandable = luasnip.expandable()
	if expandable then -- there's no popup, but the entered text is an expandable snippet
		vim.fn.feedkeys(t("<plug>luasnip-expand-snippet"))
		return
	end

	cmpFallback(key)
end

local cmpSetup = function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local icons = require("nvim-web-devicons")
	local luasnip = require("luasnip")
	local copilot_cmp_comparators = require("copilot_cmp.comparators")

	require("luasnip/loaders/from_vscode").lazy_load()

	-- clear luasnip jump points when leaving insert mode
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			while luasnip.jumpable() do
				luasnip.unlink_current()
			end
		end,
	})

	return {
		enabled = function()
			local disabled = false
			disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
			disabled = disabled or (vim.fn.reg_recording() ~= "")
			disabled = disabled or (vim.fn.reg_executing() ~= "")

			if not disabled then
				local ok, d = pcall(require("cmp.config.context").in_treesitter_capture, "comment")
				if ok then
					disabled = d
				end
			end

			return not disabled
		end,
		window = {
			completion = {
				winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
				col_offset = -3,
				side_padding = 0,
			},
		},
		preselect = require("cmp.types").cmp.PreselectMode.None,
		sources = {
			{ name = "luasnip" },
			{ name = "copilot" },
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{
				name = "buffer",
				option = {
					get_bufnrs = function()
						return vim.api.nvim_list_bufs()
					end,
				},
			},
			{ name = "path" },
			{ name = "emoji" },
			{ name = "calc" },
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				vim_item = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
					ellipsis_char = "…",
				})(entry, vim_item)

				vim_item.menu = ({
					copilot = "",
					luasnip = "",
					nvim_lsp = "",
					nvim_lua = "",
					buffer = "",
					path = "",
					emoji = "ﲃ",
					calc = "",
				})[entry.source.name]

				if entry.source.name == "path" then
					local icon = icons.get_icon(entry:get_completion_item().label)
					if icon then
						vim_item.kind = icon
					end
				else
				end

				vim_item.kind = vim_item.kind or ""
				vim_item.kind = string.format(" %s ", vim_item.kind)

				return vim_item
			end,
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		experimental = {
			ghost_text = true,
		},
		sorting = {
			priority_weight = 2,
			comparators = {
				copilot_cmp_comparators.prioritize,
				cmp.config.compare.offset, -- entries with smaller offset will be ranked higher
				cmp.config.compare.exact, -- entries with exact == true will be ranked higher
				cmp.config.compare.score, -- entries with higher score will be ranked higher
				cmp.config.compare.recently_used, -- entries that are used recently will be ranked higher
				cmp.config.compare.locality, -- entries with higher locality (i.e., words that are closer to the cursor) will be ranked higher
				cmp.config.compare.kind, -- entires with smaller ordinal value of 'kind' will be ranked higher
				cmp.config.compare.length, -- entires with shorter label length will be ranked higher
				cmp.config.compare.order, -- entries with smaller id will be ranked higher
			},
		},
		mapping = {
			["<c-p>"] = cmp.mapping.select_prev_item(),
			["<c-n>"] = cmp.mapping.select_next_item(),
			["<c-d>"] = cmp.mapping.scroll_docs(-4),
			["<c-f>"] = cmp.mapping.scroll_docs(4),
			["<down>"] = cmp.mapping.select_next_item(),
			["<up>"] = cmp.mapping.select_prev_item(),
			["<c-space>"] = cmp.mapping.complete({}),
			["<c-e>"] = cmp.mapping(function(fallback)
				complete(cmp, luasnip, fallback, "<c-e>", false)
			end),
			["<cr>"] = cmp.mapping(function(fallback)
				complete(cmp, luasnip, fallback, "<cr>", true)
			end, {
				"i",
			}),
			["<tab>"] = cmp.mapping(function(fallback)
				if vim.fn.pumvisible() == 1 then
					vim.fn.feedkeys(t("<c-n>"), "n")
				elseif cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
			["<s-tab>"] = cmp.mapping(function(fallback)
				if vim.fn.pumvisible() == 1 then
					vim.fn.feedkeys(t("<c-p>"), "n")
				elseif cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
		},
	}
end

return {
	{
		"hrsh7th/nvim-cmp",
		cond = not vim.g.vscode,
		dependencies = {
			"onsails/lspkind.nvim",
			"nvim-tree/nvim-web-devicons", -- optional dependency
			"L3MON4D3/LuaSnip",
			"zbirenbaum/copilot-cmp",
		},
		opts = cmpSetup,
	},
	{
		"hrsh7th/cmp-path",
		cond = not vim.g.vscode,
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-buffer",
		cond = not vim.g.vscode,
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-calc",
		cond = not vim.g.vscode,
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-emoji",
		cond = not vim.g.vscode,
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		cond = not vim.g.vscode,
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"hrsh7th/cmp-nvim-lua",
		cond = not vim.g.vscode,
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"saadparwaiz1/cmp_luasnip",
		cond = not vim.g.vscode,
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		cond = not vim.g.vscode,
		opts = {},
	},
	{
		"L3MON4D3/LuaSnip",
		cond = not vim.g.vscode,
	},
	{
		"rafamadriz/friendly-snippets",
		cond = not vim.g.vscode,
	},
}
