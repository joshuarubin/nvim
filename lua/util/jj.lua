-- Utilities for jujutsu (jj) integration

local M = {}

-- Store conflict metadata for partial abort support
-- Format: { bufnr = { conflicts = {...}, original_lines = {...} } }
local conflict_data = {}

local find_conflict_filetype = function()
	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ok, buftype = pcall(vim.api.nvim_buf_get_var, buf, "jj_diffconflicts_buftype")
			if ok and buftype == "conflicts" then
				return vim.api.nvim_get_option_value("filetype", { buf = buf })
			end
		end
	end
	return nil
end

local find_conflict_buffer = function()
	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ok, buftype = pcall(vim.api.nvim_buf_get_var, buf, "jj_diffconflicts_buftype")
			if ok and buftype == "conflicts" then
				return buf
			end
		end
	end
	return nil
end

local apply_filetype_to_immutable_buffers = function(filetype)
	if not filetype or filetype == "" then
		return
	end

	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ok, buftype = pcall(vim.api.nvim_buf_get_var, buf, "jj_diffconflicts_buftype")
			if ok and buftype ~= "conflicts" then
				vim.api.nvim_set_option_value("filetype", filetype, { buf = buf })
			end
		end
	end
end

-- Store original conflict data before JJDiffConflicts modifies the buffer
local store_conflict_data = function()
	local buf = find_conflict_buffer()
	if not buf then
		return
	end

	-- Get original buffer content and conflict metadata
	local ok, conflicts_var = pcall(vim.api.nvim_buf_get_var, buf, "jj_diffconflicts_conflicts")
	if not ok then
		return
	end

	-- Store the original lines before they were modified
	local original_lines = vim.api.nvim_buf_get_var(buf, "jj_diffconflicts_original_lines")

	conflict_data[buf] = {
		conflicts = conflicts_var,
		original_lines = original_lines,
	}
end

-- Close all JJDiffConflicts windows except the conflict buffer
local close_immutable_windows = function(conflict_buf)
	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
			local buf = vim.api.nvim_win_get_buf(win)
			if buf ~= conflict_buf then
				local ok = pcall(vim.api.nvim_buf_get_var, buf, "jj_diffconflicts_buftype")
				if ok then
					vim.api.nvim_win_close(win, true)
				end
			end
		end
	end
end

-- Abort JJDiffConflicts, restoring markers for unmodified hunks
M.diffconflicts_abort = function()
	local buf = find_conflict_buffer()
	if not buf then
		vim.notify("jj-diffconflicts: not in conflict resolution mode", vim.log.levels.WARN)
		return
	end

	local data = conflict_data[buf]
	if not data then
		vim.notify("jj-diffconflicts: no stored conflict data (use :e! to abort)", vim.log.levels.WARN)
		return
	end

	-- TODO: Compare current buffer state with stored conflict data
	-- and restore markers only for unmodified hunks
	-- For now, just reload the original file
	vim.cmd("e!")
	vim.cmd("diffoff")

	close_immutable_windows(buf)

	conflict_data[buf] = nil
	vim.notify("jj-diffconflicts: aborted (reloaded original file)", vim.log.levels.INFO)
end

-- Set up JJDiffConflicts enhancements (filetype sync, partial abort)
M.setup_diffconflicts = function()
	vim.api.nvim_create_autocmd("User", {
		pattern = "JJDiffConflictsReady",
		callback = function()
			local filetype = find_conflict_filetype()
			apply_filetype_to_immutable_buffers(filetype)
			store_conflict_data()
		end,
	})

	vim.api.nvim_create_user_command("JJDiffConflictsAbort", M.diffconflicts_abort, {
		desc = "Abort JJDiffConflicts and restore conflict markers",
	})
end

return M
