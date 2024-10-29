local cmp = require("luasnp.cmp")

local M = {}

M.setup = function(opts)
	opts = opts or {}
	require("cmp").register_source("luasnp", cmp)
end

return M
