local hide_false = function(cmp)
	if cmp.is_visible() then
		cmp.hide()
	end
	return false -- different from 'hide' which won't fallthrough to fallback
end

return {
	{
		"saghen/blink.cmp",
		cond = not vim.g.vscode,
		opts = function(_, opts)
			local iferr = require("iferr.adapters.blink")

			opts.sources.providers.iferr = {
				name = "iferr",
				module = "iferr.adapters.blink",
				score_offset = 100, -- show at a higher priority than lsp
			}

			table.insert(opts.sources.default, "iferr")

			opts.sources.per_filetype = {
				codecompanion = { "codecompanion" },
			}

			opts.completion.accept.auto_brackets.enabled = false
			opts.completion.accept.dot_repeat = true
			opts.completion.ghost_text.enabled = false

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

			opts.signature = {
				enabled = true,
				window = {
					border = "rounded",
				},
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
							iferr = " ",
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
			opts.keymap["<c-e>"] = { hide_false, "fallback" }
			opts.keymap["<cr>"] = {
				"accept",
				iferr.expand,
				"fallback",
			}
			opts.keymap["<s-cr>"] = {
				"accept",
				iferr.expand,
				"fallback",
			}
			-- this has to be `Tab`, not `tab`, to ensure LazyVim doesn't add an
			-- additional keymap that races with this one
			opts.keymap["<Tab>"] = {
				LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
				"select_next",
				"fallback",
			}
			opts.keymap["<s-tab>"] = {
				"select_prev",
				"snippet_backward",
				"fallback",
			}

			-- Command-line mode keymaps
			opts.cmdline = opts.cmdline or {}
			opts.cmdline.keymap = opts.cmdline.keymap or {}
			opts.cmdline.keymap["<up>"] = { "select_prev", "fallback" }
			opts.cmdline.keymap["<down>"] = { "select_next", "fallback" }

			return opts
		end,
	},
}
