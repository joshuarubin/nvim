local safe_require = require("funcs.safe_require")

local clipboard = {
	cache_enabled = 0,
}

safe_require("vim.ui.clipboard.osc52", function(osc52)
	clipboard.name = "osc52"
	clipboard.copy = {
		["+"] = osc52.copy("+"),
		["*"] = osc52.copy("*"),
	}
end)

local paste, pastestar

if vim.fn.has("mac") ~= 0 then
	paste = { "pbpaste" }
	pastestar = { "pbpaste" }
elseif vim.env.WAYLAND_DISPLAY and vim.fn.executable("wl-copy") ~= 0 and vim.fn.executable("wl-paste") ~= 0 then
	paste = { "wl-paste", "--no-newline" }
	pastestar = { "wl-paste", "--no-newline", "--primary" }
elseif vim.env.DISPLAY and vim.fn.executable("xclip") ~= 0 then
	paste = { "xclip", "-o", "-selection", "clipboard" }
	pastestar = { "xclip", "-o", "-selection", "primary" }
else
	local pastefn = function(reg)
		return function()
			return vim.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("")
		end
	end
	paste = pastefn("+")
	pastestar = pastefn("*")
end

if paste then
	clipboard.paste = {
		["+"] = paste,
		["*"] = pastestar,
	}
end

vim.g.clipboard = clipboard
