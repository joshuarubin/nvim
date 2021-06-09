local treesitter = require('nvim-treesitter.configs')

treesitter.setup {
  ensure_installed = "maintained",
  highlight = { enable = true },
}
