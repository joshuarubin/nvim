return {
	{
		"s1n7ax/nvim-window-picker",
		cond = not vim.g.vscode,
		name = "window-picker",
		event = "VeryLazy",
		version = "2.*",
		opts = {
			show_prompt = false,
			hint = "floating-big-letter",
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		cond = not vim.g.vscode,
		keys = {
			{
				"<c-n>",
				"<leader>fe",
				desc = "Explorer NeoTree (Root Dir)",
				remap = true,
			},
		},
		init = function()
			-- Exclude neo-tree buffers from session saves
			local group = vim.api.nvim_create_augroup("NeoTreeSession", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				desc = "delete neo-tree buffers before saving session",
				group = group,
				pattern = "PersistenceSavePre",
				callback = function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "neo-tree" then
							vim.api.nvim_buf_delete(buf, { force = true })
						end
					end
				end,
			})
		end,
		opts = {
			sources = { "filesystem" },
		},
	},
}
