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

			opts.sources.cmdline = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				-- Commands
				if type == ":" then
					return { "cmdline" }
				end
				return {}
			end

			opts.completion.accept.auto_brackets.enabled = false
			opts.completion.list = {
				selection = "manual",
			}

			opts.completion.menu.border = "single"
			opts.completion.documentation.window = {
				border = "single",
			}

			opts.completion.menu.draw.components = {
				source_icon = {
					width = { max = 30 },
					text = function(ctx)
						return ({
							copilot = " ",
							luasnp = "",
							snippets = "",
							lsp = "",
							buffer = "",
							path = "",
						})[ctx.source_id] or ""
					end,
					highlight = "BlinkCmpSource",
				},
			}

			opts.completion.menu.draw.columns = {
				{ "kind_icon" },
				{ "label", "label_description", gap = 1 },
				{ "source_icon" },
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
			opts.keymap["<tab>"] = {
				"select_next",
				"snippet_forward",
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
