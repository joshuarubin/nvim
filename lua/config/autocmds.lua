if vim.g.vscode then
	return
end

local init_group = vim.api.nvim_create_augroup("InitAutoCmd", {})

vim.api.nvim_create_autocmd("InsertEnter", {
	group = init_group,
	pattern = "*",
	callback = function()
		vim.o.hlsearch = false
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = init_group,
	pattern = "*",
	callback = function()
		vim.schedule(function()
			vim.o.hlsearch = true
		end)

		vim.o.paste = false
		vim.cmd.diffupdate()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "set showbreak",
	group = init_group,
	pattern = "*",
	callback = function()
		vim.wo.showbreak = "=>"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "disable showbreak for markdown files",
	group = init_group,
	pattern = { "markdown", "norg", "rmd", "org", "Avante", "blink-cmp-documentation" },
	callback = function()
		vim.wo.showbreak = ""
	end,
})

-- terminal autocommands
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "terminal normal mode mappings",
	pattern = "*",
	callback = function(ev)
		local mappings = {
			"<up>",
			"<c-r>",
		}
		for _, map in ipairs(mappings) do
			vim.keymap.set("n", map, "i" .. map, { buffer = ev.buf })
		end
	end,
})

vim.api.nvim_create_autocmd("OptionSet", {
	desc = "toggle barbecue when showing diffs, refresh gitsigns",
	pattern = "diff",
	callback = function(ev)
		if vim.wo.diff then
			local ok, barbecue = pcall(require, "barbecue.ui")
			if ok then
				barbecue.toggle(false)
			end
			return
		end

		local ok, gitsigns = pcall(require, "gitsigns")
		if ok then
			gitsigns.refresh()
		end

		local ok, barbecue = pcall(require, "barbecue.ui")
		if ok then
			barbecue.toggle(true)
		end
	end,
})
