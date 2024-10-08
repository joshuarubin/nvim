local function t(keys)
	return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

return function(dir, opts)
	opts = opts or {}
	if type(opts) == "string" then
		opts = { cmd = opts }
	end
	opts.insert = opts.insert or false

	-- normal, visual, terminal modes
	if not opts.insert then
		opts.cmd = opts.cmd or ("wincmd " .. dir)
		return function()
			vim.cmd(opts.cmd)
		end
	end

	-- insert mode
	return function()
		if vim.fn.pumvisible() == 1 then
			if dir == "j" then
				vim.fn.feedkeys(t("<c-n>" .. dir))
				return
			end

			if dir == "k" then
				vim.fn.feedkeys(t("<c-p>" .. dir))
				return
			end
		end

		local ok, cmp = pcall(require, "cmp")
		if ok then
			if cmp.visible() then
				if dir == "j" then
					cmp.select_next_item()
					return
				end

				if dir == "k" then
					cmp.select_prev_item()
					return
				end
			end
		end

		vim.fn.feedkeys(t("<c-\\><c-n>"))
		if opts.cmd then
			vim.cmd(opts.cmd)
		else
			vim.fn.feedkeys(t("<c-w>" .. dir))
		end
		vim.fn.feedkeys(t("<c-w>" .. dir))
	end
end
