local git_dir = function(file)
	file = file or "%"
	local file_dir = vim.fn.expand(file .. ":p:h")
	local handle = io.popen("cd " .. file_dir .. " && git rev-parse --git-dir")
	if handle == nil then
		return ""
	end

	local dir = handle:read("*a")
	if dir:find("/", 1, true) == nil then
		dir = vim.fn.simplify(file_dir .. "/" .. dir)
	end
	dir = dir:gsub(".git", "")

	local result = vim.fn.fnamemodify(dir, ":p")
	handle:close()
	return vim.trim(result)
end

local git_opts = {}

local keys = {
	{
		"<leader>gs",
		function()
			git_opts.dir = git_dir()
			require("neogit").open({ cwd = git_opts.dir })
		end,
		desc = "git status",
	},
}

local neogit_bindings = {
	["<leader>gc"] = { "commit", "git commit" },
	["<leader>gl"] = { "log", "git log" },
	["<leader>gp"] = { "push", "git push" },
	["<leader>gu"] = { "pull", "git pull" },
	["<leader>gr"] = { "rebase", "git rebase" },
	["<leader>gz"] = { "stash", "git stash" },
	["<leader>gZ"] = { "stash", "git stash" },
	["<leader>gb"] = { "branch", "git branch" },
}

for k, v in pairs(neogit_bindings) do
	table.insert(keys, {
		k,
		function()
			git_opts.dir = git_dir()
			require("neogit").open({ v[1] })
		end,
		desc = v[2],
	})
end

vim.cmd.highlight("GitSignsCurrentLineBlame gui=italic guifg=#564d43")

return {
	{
		"sindrets/diffview.nvim",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"TimUntersberger/neogit",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			kind = "split",
			disable_signs = true,
			graph_style = "unicode",
			auto_close_console = false,
			integrations = {
				telescope = true,
				diffview = true,
			},
		},
		keys = keys,
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "Neogit*",
				callback = function()
					if git_opts.dir then
						vim.cmd("lcd " .. git_opts.dir)
					end
				end,
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			signs = {
				add = { text = "█│" },
				change = { text = "█┆" },
				delete = { text = "█▁" },
				topdelete = { text = "█▔" },
				changedelete = { text = "█▟" },
			},
			signs_staged_enable = false,
			trouble = true,
			current_line_blame = true,
			current_line_blame_opts = { delay = 0 },
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				-- Navigation
				vim.keymap.set("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "next hunk" })

				vim.keymap.set("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "prev hunk" })

				-- Actions
				vim.keymap.set(
					{ "n", "v" },
					"<leader>hs",
					":Gitsigns stage_hunk<CR>",
					{ buffer = bufnr, desc = "stage hunk" }
				)
				vim.keymap.set(
					{ "n", "v" },
					"<leader>hr",
					":Gitsigns reset_hunk<CR>",
					{ buffer = bufnr, desc = "reset hunk" }
				)
				vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "stage buffer" })
				vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "undo stage hunk" })
				vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "git reset buffer" })
				vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "preview hunk" })
				vim.keymap.set("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, { buffer = bufnr, desc = "blame line" })
				vim.keymap.set("n", "<leader>gw", function()
					gs.blame_line({ full = true })
				end, { buffer = bufnr, desc = "blame line" })
				vim.keymap.set(
					"n",
					"<leader>tb",
					gs.toggle_current_line_blame,
					{ buffer = bufnr, desc = "toggle current line blame" }
				)
				vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "diff this" })
				vim.keymap.set("n", "<leader>gd", gs.diffthis, { buffer = bufnr, desc = "diff this" })
				vim.keymap.set("n", "<leader>hD", function()
					gs.diffthis("~")
				end, { buffer = bufnr, desc = "diff this ~" })
				vim.keymap.set("n", "<leader>td", gs.toggle_deleted, { buffer = bufnr, desc = "git toggle deleted" })

				-- Text object
				vim.keymap.set(
					{ "o", "x" },
					"ih",
					":<C-U>Gitsigns select_hunk<CR>",
					{ buffer = bufnr, desc = "select hunk" }
				)

				vim.api.nvim_set_option_value("eol", false, { buf = bufnr })
			end,
		},
	},
}
