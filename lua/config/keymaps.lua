require("config.vscode")

-- normal mode
vim.keymap.set("n", "<leader>n", "<cmd>nohlsearch<cr>", { desc = "nohlsearch" })
vim.keymap.set("n", "<leader>fc", "/\\v^[<|=>]{7}( .*|$)<cr>", { desc = "find merge conflict markers" })

vim.keymap.set("n", "d", '"_d', { desc = "delete into blackhole register to not clobber the last yank" })
vim.keymap.set("n", "dd", "dd", { desc = "delete and yank the current line" })
vim.keymap.set("n", "c", '"_c', { desc = "change into the blackhole register to not clobber the last yank" })
vim.keymap.set("n", "W", "<cmd>w<cr>", { desc = "write the buffer to the current file" })

-- allow remap on these to get them working with vscode
vim.keymap.set("n", "_", "<c-w>s", { desc = "horizontal split current window", remap = true })
vim.keymap.set("n", "<bar>", "<c-w>v", { desc = "vertical split current window", remap = true })

-- visual mode
vim.keymap.set("x", "y", "y`]", { desc = "yank and go to end of selection" })
vim.keymap.set(
	"x",
	"p",
	'"_dP',
	{ desc = "paste in visual mode should not replace the default register with the deleted text" }
)
vim.keymap.set(
	"x",
	"d",
	'"_d',
	{ desc = "delete into the blackhole register to not clobber the last yank. To 'cut', use 'x' instead" }
)
vim.keymap.set("x", "<cr>", 'y<cmd>let @/ = @"<cr><cmd>set hlsearch<cr>', { desc = "highlight visual selections" })
vim.keymap.set("x", "<", "<gv", { desc = "retain visual selection after indent" })
vim.keymap.set("x", ">", ">gv", { desc = "retain visual selection after indent" })
vim.keymap.set("x", ".", ":normal.<cr>", { silent = true, desc = "repeats the last command on every line" })
vim.keymap.set("x", "@", ":normal@@<cr>", { silent = true, desc = "repeats the last macro on every line" })
vim.keymap.set("x", "<tab>", ">", { remap = true, desc = "indent" })
vim.keymap.set("x", "<s-tab>", "<", { remap = true, desc = "unindent" })

-- visual and select mode
vim.keymap.set("v", "<leader>s", ":sort<cr>", { desc = "sort" })

-- insert mode
vim.keymap.set("i", "<c-w>", "<c-g>u<c-w>", { desc = "delete previous word, create undo point" })

local function t(keys)
	return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

vim.keymap.set("n", "<leader>g.", function()
	vim.cmd("lcd " .. vim.fn.expand("%:p:h"))
	local dir = vim.fn.system("git rev-parse --git-dir"):gsub(".git", "")
	dir = vim.trim(dir)
	if dir ~= "" then
		dir = vim.fn.fnamemodify(dir, ":p")
		vim.cmd("lcd " .. dir)
	end
end, { desc = "lcd to git root dir" })

-- undo
for _, lhs in ipairs({ "<d-z>" }) do
	vim.keymap.set("n", lhs, "<undo>", { desc = "undo" })
	vim.keymap.set("i", lhs, function()
		vim.cmd(t("normal <undo>"))
		vim.api.nvim_feedkeys(t("<right>"), "n", false)
	end, { desc = "undo" })
end

-- resize
vim.keymap.set({ "n", "v" }, "<c-a>H", "<c-w><", { desc = "decrease current window width" })
vim.keymap.set({ "n", "v" }, "<c-a>J", "<c-w>+", { desc = "increase current window height" })
vim.keymap.set({ "n", "v" }, "<c-a>K", "<c-w>-", { desc = "decrease current window height" })
vim.keymap.set({ "n", "v" }, "<c-a>L", "<c-w>>", { desc = "increase current window width" })

vim.keymap.set({ "n", "v" }, "<d-h>", "<c-w><", { desc = "decrease current window width" })
vim.keymap.set({ "n", "v" }, "<d-j>", "<c-w>+", { desc = "increase current window height" })
vim.keymap.set({ "n", "v" }, "<d-k>", "<c-w>-", { desc = "decrease current window height" })
vim.keymap.set({ "n", "v" }, "<d-l>", "<c-w>>", { desc = "increase current window width" })

vim.keymap.set(
	"i",
	"<c-a>H",
	'<c-r>=execute("normal! \\<lt>c-w><")<cr>',
	{ silent = true, desc = "decrease current window width" }
)
vim.keymap.set(
	"i",
	"<c-a>J",
	'<c-r>=execute("normal! \\<lt>c-w>+")<cr>',
	{ silent = true, desc = "increase current window height" }
)
vim.keymap.set(
	"i",
	"<c-a>K",
	'<c-r>=execute("normal! \\<lt>c-w>-")<cr>',
	{ silent = true, desc = "decrease current window height" }
)
vim.keymap.set(
	"i",
	"<c-a>L",
	'<c-r>=execute("normal! \\<lt>c-w>>")<cr>',
	{ silent = true, desc = "increase current window width" }
)

vim.keymap.set(
	"i",
	"<d-h>",
	'<c-r>=execute("normal! \\<lt>c-w><")<cr>',
	{ silent = true, desc = "decrease current window width" }
)
vim.keymap.set(
	"i",
	"<d-j>",
	'<c-r>=execute("normal! \\<lt>c-w>+")<cr>',
	{ silent = true, desc = "increase current window height" }
)
vim.keymap.set(
	"i",
	"<d-k>",
	'<c-r>=execute("normal! \\<lt>c-w>-")<cr>',
	{ silent = true, desc = "decrease current window height" }
)
vim.keymap.set(
	"i",
	"<d-l>",
	'<c-r>=execute("normal! \\<lt>c-w>>")<cr>',
	{ silent = true, desc = "increase current window width" }
)

vim.keymap.set("t", "<c-a>H", "<c-\\><c-n><c-w><i", { desc = "decrease current window width" })
vim.keymap.set("t", "<c-a>J", "<c-\\><c-n><c-w>+i", { desc = "increase current window height" })
vim.keymap.set("t", "<c-a>K", "<c-\\><c-n><c-w>-i", { desc = "decrease current window height" })
vim.keymap.set("t", "<c-a>L", "<c-\\><c-n><c-w>>i", { desc = "increase current window width" })

vim.keymap.set("t", "<d-h>", "<c-\\><c-n><c-w><i", { desc = "decrease current window width" })
vim.keymap.set("t", "<d-j>", "<c-\\><c-n><c-w>+i", { desc = "increase current window height" })
vim.keymap.set("t", "<d-k>", "<c-\\><c-n><c-w>-i", { desc = "decrease current window height" })
vim.keymap.set("t", "<d-l>", "<c-\\><c-n><c-w>>i", { desc = "increase current window width" })

-- normal mode
vim.keymap.set("n", "<leader>cd", "<cmd>lcd %:p:h<cr>:pwd<cr>", { desc = "switch to the directory of the open buffer" })
vim.keymap.set("n", "<leader>=", "<c-w>=", { desc = "adjust viewports to the same size" })
vim.keymap.set("n", "Q", "<cmd>q<cr>", { desc = "quit the current window" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "exit vim losing changes" })
vim.keymap.set("n", "<c-a>r", "<cmd>redraw!<cr>", { desc = "redraw the screen" })

-- command line mode
vim.keymap.set("c", "<c-j>", "<down>", { desc = "down" })
vim.keymap.set("c", "<c-k>", "<up>", { desc = "up" })

local safe_require = require("util.safe_require")

vim.keymap.set("c", "<cr>", function()
	if vim.fn.wildmenumode() == 1 then
		vim.fn.feedkeys(t("<c-y>"))
		if not vim.fn.getcmdline():match("/$") then
			vim.fn.feedkeys(t("<cr>"))
		end
		return ""
	end

	local accepted
	safe_require("blink.cmp", function(cmp)
		if cmp.is_visible() then
			accepted = cmp.accept()
		end
	end)

	if accepted then
		return ""
	end

	return "<cr>"
end, { expr = true })

-- terminal mode
vim.keymap.set("t", "<c-y>", "<c-\\><c-n><c-y>", { desc = "scroll up one line" })
vim.keymap.set("t", "<c-u>", "<c-\\><c-n><c-u>", { desc = "scroll up half a screen" })

vim.keymap.set({ "n", "t" }, "<c-x>", "<c-/>", { remap = true, desc = "Terminal (Root Dir)" })
Snacks.toggle.zoom():map("<leader>m")

-- pick window and go to it
vim.keymap.set("n", "<leader>wp", function()
	local picked_window_id = require("window-picker").pick_window({
		filter_rules = {
			bo = {
				filetype = {},
				buftype = {},
			},
		},
	})
	if not picked_window_id then
		return
	end
	vim.api.nvim_set_current_win(picked_window_id)
end, { desc = "Pick and Switch to Window" })

vim.keymap.set("n", "<c-b>", "<leader>,", { remap = true, desc = "Switch Buffer" })
vim.keymap.set("n", "<c-p>", "<leader><space>", { remap = true, desc = "Find Files (Root Dir)" })
vim.keymap.set("n", "<c-f>", "<leader>fr", { remap = true, desc = "Recent" })
vim.keymap.set("n", "<c-s><c-s>", "<leader>sw", { remap = true, desc = "Word (Root Dir)" })
vim.keymap.set("v", "<c-s><c-s>", "<leader>sw", { remap = true, desc = "Selection (Root Dir)" })
vim.keymap.set("n", "<c-s><c-d>", "<leader>sg", { remap = true, desc = "Grep (Root Dir)" })

vim.keymap.set("n", "<leader>N", function()
	Snacks.notifier.show_history()
end, { desc = "Notification History" })

vim.keymap.set("n", "<c-w><c-w>", function()
	Snacks.bufdelete.delete()
end, { desc = "Delete the current buffer without closing the window" })

vim.keymap.set(
	"v",
	"p",
	"P",
	{ desc = "visual put without putting the previously selected text in the unnamed register" }
)

-- delete lazyvim keymaps
vim.keymap.del({ "i", "x", "n", "s" }, "<c-s>")
vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "k")

-- fix abbreviations in lazyvim esc keymap in insert mode
vim.keymap.set("i", "<esc>", function()
	vim.cmd("nohlsearch")
	LazyVim.cmp.actions.snippet_stop()
	return "<c-]><esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })
