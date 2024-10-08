return function(modules, callback)
	if type(modules) == "string" then
		modules = { modules }
	end

	local mods = {}

	for _, module in ipairs(modules) do
		local ok, mod = pcall(require, module)
		if not ok then
			vim.notify(module .. " not found", vim.log.levels.WARN)
			return
		end

		table.insert(mods, mod)
	end

	callback(unpack(mods))
end
