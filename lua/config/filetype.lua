vim.filetype.add({
	extension = {
		tf = "terraform",
		es6 = "javascript",
		service = "systemd",
		gohtml = "gohtml",
		gotmpl = function(path, _)
			-- Check for compound extensions and use the base language filetype
			if path:match("%.go%.gotmpl$") then
				return "go"
			elseif path:match("%.ya?ml%.gotmpl$") then
				return "yaml"
			elseif path:match("%.json%.gotmpl$") then
				return "json"
			elseif path:match("%.toml%.gotmpl$") then
				return "toml"
			end
			-- Plain .gotmpl files get template-only syntax
			return "gotmpl"
		end,
	},
})
