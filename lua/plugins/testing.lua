--[[
testing.lua - Testing and API Tools

Plugins:
- kulala.nvim: REST API client for testing HTTP requests

Organization rule: Testing tools and API clients (room to grow)
See: lua/plugins/init.lua for placement guidelines
--]]

return {
	-- REST API client for testing HTTP requests in .http files
	{
		"mistweaverco/kulala.nvim",
		opts = {
			contenttypes = {
				-- Custom content type handler for RFC 9457 problem details
				-- Copied from default application/json config
				["application/problem+json"] = {
					ft = "json",
					-- Use jq for formatting if available
					formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
					pathresolver = function(...)
						return require("kulala.parser.jsonpath").parse(...)
					end,
				},
			},
		},
	},
}
