--[[
Custom LSP Commands with Event Emission

This module provides custom implementations of :LspStart, :LspStop, and :LspRestart
that emit User autocmd events, allowing other plugins to hook into LSP lifecycle events.

Events emitted (all use pattern "User" with the following patterns):
- LspStartPre:   Before starting each server    (event.data = server_name)
- LspStartPost:  After starting each server     (event.data = server_name)
- LspStopPre:    Before stopping each client    (event.data = client_name)
- LspStopPost:   After stopping each client     (event.data = client_name)
- LspRestartPre: Before restarting each client  (event.data = client_name)
- LspRestartPost: After restarting each client  (event.data = client_name)

Example usage in plugins/ai.lua:
  vim.api.nvim_create_autocmd("User", {
    pattern = "LspRestartPost",
    callback = function(event)
      if event.data == "copilot" then
        -- Handle Copilot-specific restart logic
      end
    end,
  })

Note: Events are emitted per-server/per-client, not once per command invocation.
For example, :LspStart with no args in a Go file will emit events for each
matching server (gopls, golangci_lint_ls, etc.).

Deferred Loading Guard

This module creates custom :LspStart, :LspStop, and :LspRestart commands that work
independently of lspconfig (using native vim.lsp APIs). However, when nvim-lspconfig
loads, it creates its own versions of these commands, overwriting ours. This guard
ensures we re-define our commands after lspconfig loads to maintain our overrides.

How it works:
1. Check if :LspRestart command exists (lspconfig creates it on load)
2. If not, set up a User autocmd listening for the "LazyLoad" event
3. When lspconfig loads, Lazy emits User LazyLoad with event.data = "nvim-lspconfig"
4. Clear this module from require's cache and re-require it
5. On second load, the guard passes and the full setup executes
6. Delete the autocmd group to clean up
--]]

-- Table of client names that manage their own restart/start logic
-- Plugins can register themselves here to skip vim.lsp.start() in LspRestart
-- Also used to add servers to LspStart completion if they have vim.lsp.config entries
_G.util_lsp_self_managed_clients = _G.util_lsp_self_managed_clients or {}

local M = {}

--- Register a client as self-managed (doesn't need vim.lsp.start on restart)
--- If the client has a vim.lsp.config entry, it will also appear in LspStart completion
---@param client_name string The name of the LSP client
M.register_self_managed = function(client_name)
	_G.util_lsp_self_managed_clients[client_name] = true
end

--- Create autocmd callback that only runs for specific LSP client(s)
---@param clients string|string[] Client name(s) to match
---@param callback fun(event: vim.api.keyset.create_autocmd.callback_args) Callback to invoke when client matches
---@return function Autocmd callback function
M.on_client = function(clients, callback)
	if type(clients) == "string" then
		clients = { clients }
	end

	---@param event vim.api.keyset.create_autocmd.callback_args
	return function(event)
		if vim.tbl_contains(clients, event.data) then
			callback(event)
		end
	end
end

local lspconfig = "nvim-lspconfig"

-- Check if lspconfig has actually created its commands, not just if it's registered
if vim.fn.exists(":LspRestart") == 0 then
	local util_lsp = vim.api.nvim_create_augroup("UtilLSPAutoTriggerGuard", {})

	vim.api.nvim_create_autocmd("User", {
		group = util_lsp,
		pattern = "LazyLoad",
		callback = function(event)
			if event.data ~= lspconfig then
				return
			end

			-- Lua's require() caches modules in package.loaded after first load. Subsequent
			-- require() calls return the cached result without re-executing the file.
			-- Clear the cache to force re-execution, allowing the guard to pass on second load.
			package.loaded["util.lsp"] = nil
			require("util.lsp")
			vim.api.nvim_del_augroup_by_id(util_lsp)
		end,
	})

	return M
end

local completion_sort = function(items)
	local unique = {}
	for _, item in ipairs(items) do
		unique[item] = true
	end
	local result = vim.tbl_keys(unique)
	table.sort(result)
	return result
end

M.lsp_get_active_clients = function(arg)
	local clients = vim.tbl_map(function(client)
		return ("%s"):format(client.name)
	end, vim.lsp.get_clients())

	return completion_sort(vim.tbl_filter(function(s)
		return s:sub(1, #arg) == arg
	end, clients))
end

local available_servers = function()
	-- Get statically configured servers from _configs
	---@diagnostic disable-next-line: invisible
	local configs = vim.lsp.config and vim.lsp.config._configs or {}
	local servers = vim.tbl_filter(function(name)
		return name ~= "*"
	end, vim.tbl_keys(configs))

	-- Add self-managed clients that have vim.lsp.config entries
	local seen = {}
	for _, name in ipairs(servers) do
		seen[name] = true
	end

	for name, _ in pairs(_G.util_lsp_self_managed_clients) do
		if not seen[name] and vim.lsp.config and vim.lsp.config[name] then
			table.insert(servers, name)
		end
	end

	return servers
end

M.lsp_complete_configured_servers = function(arg)
	return completion_sort(vim.tbl_filter(function(s)
		return s:sub(1, #arg) == arg
	end, available_servers()))
end

---@return vim.lsp.Client[] clients
M.get_clients_from_cmd_args = function(arg)
	local result = {}
	local managed_clients = vim.lsp.get_clients()
	local clients = {}
	for _, client in pairs(managed_clients) do
		clients[client.name] = client
	end

	local err_msg = ""
	arg = arg:gsub("[%a-_]+", function(name)
		if clients[name] then
			return clients[name].id
		end
		err_msg = err_msg .. ('config "%s" not found\n'):format(name)
		return ""
	end)
	for id in (arg or ""):gmatch("(%d+)") do
		local client = vim.lsp.get_client_by_id(assert(tonumber(id)))
		if client == nil then
			err_msg = err_msg .. ('client id "%s" not found\n'):format(id)
		end
		result[#result + 1] = client
	end

	if err_msg ~= "" then
		vim.notify(("%s:\n%s"):format(lspconfig, err_msg:sub(1, -2)), vim.log.levels.WARN)
		return result
	end

	if #result == 0 then
		return managed_clients
	end
	return result
end

---@param filetype string
---@return string[] server_names
function M.get_server_names_by_ft(filetype)
	local matching_names = {}
	for name, config in pairs(vim.lsp.config or {}) do
		local filetypes = config.filetypes or {}
		for _, ft in pairs(filetypes) do
			if ft == filetype then
				table.insert(matching_names, name)
				break
			end
		end
	end
	return matching_names
end

local emit = function(event, data)
	vim.api.nvim_exec_autocmds("User", {
		pattern = event,
		data = data,
	})
end

--- @class util.lsp.start.Opts
--- @field opts vim.lsp.start.Opts? Optional keyword arguments.
--- @field event_prefix string? Optional event prefix name

--- @param client_name string Name of the LSP client to start.
--- @param opts util.lsp.start.Opts? Optional start options.
--- @return integer? client_id
local lsp_start = function(client_name, opts)
	local config = vim.lsp.config[client_name]
	if not config then
		return 0
	end

	opts = opts or {}

	if opts.event_prefix then
		emit(opts.event_prefix .. "Pre", client_name)
	end

	if not _G.util_lsp_self_managed_clients[client_name] then
		-- vim.lsp.start() requires root_dir as string, not function
		if type(config.root_dir) == "function" then
			config.root_dir = nil
		end
		vim.lsp.start(config, opts.opts)
	end

	if opts.event_prefix then
		emit(opts.event_prefix .. "Post", client_name)
	end
end

---@param info {name:string, args:string, fargs:string[], bang:boolean, line1:number, line2:number, range:number, count:number, reg:string, mods:string, smods:table}
M.lsp_start = function(info)
	local server_name = string.len(info.args) > 0 and info.args or nil

	--- @type util.lsp.start.Opts
	local opts = { event_prefix = "LspStart" }

	if server_name then
		-- Start specific server by name
		lsp_start(server_name, opts)
		return
	end

	-- Start all servers matching current filetype
	local matching_names = M.get_server_names_by_ft(vim.bo.filetype)
	for _, name in ipairs(matching_names) do
		lsp_start(name, opts)
	end
end

---@param info {name:string, args:string, fargs:string[], bang:boolean, line1:number, line2:number, range:number, count:number, reg:string, mods:string, smods:table}
M.lsp_stop = function(info)
	---@type string
	local args = info.args
	local force = false
	args = args:gsub("%+%+force", function()
		force = true
		return ""
	end)

	local clients = {}

	-- default to stopping all servers on current buffer
	if #args == 0 then
		clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	else
		clients = M.get_clients_from_cmd_args(args)
	end

	for _, client in ipairs(clients) do
		emit("LspStopPre", client.name)
		client:stop(force)
		emit("LspStopPost", client.name)
	end
end

---@param info {name:string, args:string, fargs:string[], bang:boolean, line1:number, line2:number, range:number, count:number, reg:string, mods:string, smods:table}
M.lsp_restart = function(info)
	local detach_clients = {}
	for _, client in ipairs(M.get_clients_from_cmd_args(info.args)) do
		emit("LspRestartPre", client.name)
		client:stop()
		if vim.tbl_count(client.attached_buffers) > 0 then
			detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
		end
	end

	local timer = assert(vim.uv.new_timer())
	timer:start(
		500,
		100,
		vim.schedule_wrap(function()
			for client_name, tuple in pairs(detach_clients) do
				local client, attached_buffers = unpack(tuple)
				if client.is_stopped() then
					-- Restart client on all previously attached buffers
					-- Self-managed clients handle their own restart via LspRestartPost event
					for _, buf in pairs(attached_buffers) do
						if vim.api.nvim_buf_is_valid(buf) then
							lsp_start(client_name, { opts = { bufnr = buf } })
						end
					end
					emit("LspRestartPost", client_name)
					detach_clients[client_name] = nil
				end
			end

			if next(detach_clients) == nil and not timer:is_closing() then
				timer:close()
			end
		end)
	)
end

vim.api.nvim_create_user_command("LspStart", M.lsp_start, {
	desc = "Manually launches a language server",
	nargs = "?",
	complete = M.lsp_complete_configured_servers,
})

vim.api.nvim_create_user_command("LspStop", M.lsp_stop, {
	desc = "Manually stops the given language client(s)",
	nargs = "?",
	complete = M.lsp_get_active_clients,
})

vim.api.nvim_create_user_command("LspRestart", M.lsp_restart, {
	desc = "Manually restart the given language client(s)",
	nargs = "?",
	complete = M.lsp_get_active_clients,
})

return M
