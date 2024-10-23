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
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"NeogitOrg/neogit",
		lazy = false,
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
			vim.api.nvim_create_autocmd("BufWinEnter", {
				pattern = "diffview://*",
				callback = function(ev)
					if vim.wo.diff then
						return
					end
					pcall(vim.api.nvim_buf_del_keymap, ev.buf, "n", "<esc>")
				end,
			})
			vim.api.nvim_create_autocmd("OptionSet", {
				callback = function(ev)
					if not vim.wo.diff then
						return
					end
					if pcall(vim.api.nvim_buf_del_keymap, ev.buf, "n", "<esc>") then
						return
					end
				end,
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "█│" },
				change = { text = "█┆" },
				delete = { text = "█▁" },
				topdelete = { text = "█▔" },
				changedelete = { text = "█▟" },
			},
			signs_staged = {
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

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next Hunk")

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Prev Hunk")

				map("n", "]C", function()
					gs.nav_hunk("last")
				end, "Last Hunk")

				map("n", "[C", function()
					gs.nav_hunk("first")
				end, "First Hunk")

				map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
				map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
				map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
				map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, "Blame Line")
				map("n", "<leader>ghB", function()
					gs.blame()
				end, "Blame Buffer")
				map("n", "<leader>ghd", gs.diffthis, "Diff This")
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, "Diff This ~")
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")

				vim.keymap.set("n", "<leader>gd", "<leader>ghd", { remap = true, buffer = bufnr, desc = "Diff This" })
			end,
		},
	},
}
