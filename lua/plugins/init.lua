return {
	"tpope/vim-surround", -- quoting/parenthesizing made simple
	"tpope/vim-repeat", -- enable repeating supported plugin maps with `.`
	"tpope/vim-eunuch", -- helpers for unix
	"tpope/vim-abolish", -- easily search for, substitute, and abbreviate multiple variants of a word

	{
		"direnv/direnv.vim",
		cond = not vim.g.vscode,
	},
}
