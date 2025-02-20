return {
	{
		"saghen/blink.cmp",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			local luasnp = require("luasnp.blink")

			opts.sources.providers.luasnp = {
				name = "luasnp",
				module = "luasnp.blink",
				score_offset = 100, -- show at a higher priority than lsp
			}

			table.insert(opts.sources.default, "luasnp")

			opts.sources.per_filetype = {
				codecompanion = { "codecompanion" },
			}

			opts.completion.accept.auto_brackets.enabled = false
			opts.completion.accept.dot_repeat = false

			opts.completion.list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			}

			opts.completion.menu.border = "single"
			opts.completion.documentation.window = {
				border = "single",
			}

			local lsp_name = function(ctx)
				if ctx.source_id ~= "lsp" then
					return
				end

				if ctx.item == nil then
					return
				end

				return ctx.item.client_name
			end

			opts.completion.menu.draw.components = {
				source_icon = {
					width = { max = 30 },
					text = function(ctx)
						return ({
							copilot = " ",
							luasnp = " ",
							snippets = " ",
							lsp = " ",
							buffer = " ",
							path = " ",
						})[ctx.source_id] or ""
					end,
					highlight = "BlinkCmpSource",
				},
				client_name = {
					width = { max = 30 },
					text = function(ctx)
						local cn = lsp_name(ctx)
						if cn ~= nil then
							return "[" .. cn .. "]"
						end
					end,
					highlight = "BlinkCmpSource",
				},
			}

			opts.completion.menu.draw.columns = {
				{ "kind_icon" },
				{ "label", "label_description", gap = 1 },
				{ "source_icon", "source_name", "client_name", gap = 1 },
			}

			opts.keymap.preset = "none"

			opts.keymap["<c-k>"] = { "select_prev", "fallback" }
			opts.keymap["<c-j>"] = { "select_next", "fallback" }

			opts.keymap["<c-d>"] = { "scroll_documentation_up", "fallback" }
			opts.keymap["<c-f>"] = { "scroll_documentation_down", "fallback" }
			opts.keymap["<c-p>"] = { "select_prev", "fallback" }
			opts.keymap["<c-n>"] = { "select_next", "fallback" }
			opts.keymap["<down>"] = { "select_next", "fallback" }
			opts.keymap["<up>"] = { "select_prev", "fallback" }
			opts.keymap["<c-space>"] = { "show" }
			opts.keymap["<s-cr>"] = { "accept", "fallback" }
			opts.keymap["<c-cr>"] = { "cancel", "fallback" }
			opts.keymap["<c-y>"] = { "select_and_accept", "fallback" }
			opts.keymap["<c-e>"] = { "hide", "fallback" }
			opts.keymap["<cr>"] = {
				"accept",
				luasnp.expand,
				"fallback",
			}
			opts.keymap["<s-cr>"] = {
				"accept",
				luasnp.expand,
				"fallback",
			}
			-- this has to be `Tab`, not `tab`, to ensure LazyVim doesn't add an
			-- additional keymap that races with this one
			opts.keymap["<Tab>"] = {
				"select_next",
				LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
				"fallback",
			}
			opts.keymap["<s-tab>"] = {
				"select_prev",
				"snippet_backward",
				"fallback",
			}

			return opts
		end,
	},
}
