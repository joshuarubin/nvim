if not vim.g.vscode then
	return
end

local ok, vscode = pcall(require, "vscode")
if not ok then
	return
end

for _, dir in ipairs({ "h", "j", "k", "l" }) do
	local cmd = "<c-w>" .. dir

	-- normal, visual modes
	vim.keymap.set({ "n", "v" }, "<c-" .. dir .. ">", cmd, { remap = true })

	-- insert mode
	vim.keymap.set("i", "<c-" .. dir .. ">", "<c-\\><c-n>" .. cmd, { remap = true })
end

vim.keymap.set("n", "<c-w><c-w>", "<cmd>Quit<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>Qall<cr>")
vim.keymap.set("n", "<leader>Q", "<cmd>Qall!<cr>")
vim.keymap.set("n", "<leader>=", function()
	vscode.action("workbench.action.evenEditorWidths")
end)
