---@meta

--- Internal context format used by luasnp snippets
--- This is NOT blink.cmp.Context - it's a transformed version with 0-indexed cursor for treesitter
---@class luasnp.Context
---@field bufnr number
---@field cursor {line: number, col: number}  -- 0-indexed for treesitter API
---@field filetype? string  -- Optional, used for filetype-specific snippets
