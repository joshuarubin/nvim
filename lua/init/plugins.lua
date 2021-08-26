-- Install packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

local packer = require('packer')
local use = packer.use

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup END
]]

packer.startup(function()
  use 'wbthomason/packer.nvim' -- package manager
  use 'ton/vim-bufsurf' -- switch buffers based on viewing history per window
  use 'mhinz/vim-startify' -- " shows recently used files, bookmarks and sessions
  use 'tpope/vim-surround' -- quoting/parenthesizing made simple
  use 'tpope/vim-repeat' -- enable repeating supported plugin maps with `.`
  use 'tpope/vim-eunuch' -- helpers for unix
  use 'tpope/vim-endwise' -- wisely add "end" in ruby, endfunction/endif/more in vim script, etc.
  use 'tomtom/tcomment_vim' -- easy to use, file-type sensible comments
  use 'editorconfig/editorconfig-vim'
  use 'osyo-manga/vim-anzu' -- search status
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'simrat39/rust-tools.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'

  -- completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-calc'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-vsnip'

  -- snippets
  use 'hrsh7th/vim-vsnip'
  use 'rafamadriz/friendly-snippets'

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    },
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'jvgrootveld/telescope-zoxide'
  use 'AckslD/nvim-neoclip.lua'

  use 'tpope/vim-fugitive'
  use 'folke/trouble.nvim'

  use 'joshuarubin/terminal.vim'
  use 'joshuarubin/rubix.vim'
  use 'joshuarubin/rubix-lightline.vim'
  use 'joshuarubin/rubix-telescope.nvim'

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }

  -- lightline
  use 'itchyny/lightline.vim' -- a light and configurable statusline/tabline
  use 'mengelbrecht/lightline-bufferline' -- provides bufferline functionality for lightline

  -- file type icons
  use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons'

  -- colorscheme
  use 'cocopon/iceberg.vim'
  use 'folke/lsp-colors.nvim'
end)

-- bufsurf
vim.api.nvim_set_keymap("n", "Z", vim.api.nvim_replace_termcodes(":BufSurfBack<cr>",    true, true, true), {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "X", vim.api.nvim_replace_termcodes(":BufSurfForward<cr>", true, true, true), {silent = true, noremap = true})

-- startify
vim.g.startify_session_dir = vim.fn.stdpath('data') .. '/sessions'
vim.g.startify_show_sessions = 1
vim.g.startify_session_persistence = 1
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_update_oldfiles = 1
vim.g.startify_session_sort = 1
vim.g.startify_custom_header = ""
vim.g.startify_skiplist = vim.fn.add(
  vim.fn.map(vim.split(vim.o.runtimepath, ','), function(_, v)
    return vim.fn.resolve(v .. '/doc')
  end),
  'COMMIT_EDITMSG'
)
vim.api.nvim_set_keymap("n", "<leader>bh", vim.api.nvim_replace_termcodes(":Startify<cr>", true, true, true), {silent = true})

-- endwise
vim.g.endwise_no_mappings = 1

-- editorconfig
vim.fn['editorconfig#AddNewHook'](function(config)
  if config['vim_filetype'] ~= nil then
    vim.bo.filetype = config['vim_filetype']
  end
  return 0 -- return 0 to show no error happened
end)

-- anzu
vim.api.nvim_set_keymap("n", "n", "<plug>(anzu-n-with-echo)", {})
vim.api.nvim_set_keymap("n", "N", "<plug>(anzu-N-with-echo)", {})
vim.api.nvim_set_keymap("n", "*", "<plug>(anzu-star-with-echo)", {})
vim.api.nvim_set_keymap("n", "#", "<plug>(anzu-sharp-with-echo)", {})

-- snippets
vim.g.vsnip_snippet_dir = vim.fn.stdpath('data') .. '/snippets'

-- gitsigns
require('gitsigns').setup {
  signs = {
    add =          { hl = 'GitGutterAdd',    text = '█|' },
    change =       { hl = 'GitGutterChange', text = '█⫶' },
    delete =       { hl = 'GitGutterDelete', text = '█▁' },
    topdelete =    { hl = 'GitGutterDelete', text = '█▔' },
    changedelete = { hl = 'GitGutterChange', text = '█▟' },
  },
}

-- colorscheme
vim.o.termguicolors = true
vim.cmd [[autocmd ColorScheme * highlight Comment gui=italic cterm=italic]]
vim.cmd [[colorscheme iceberg]]
vim.cmd [[call matchadd('Error', 'TODO', -1)]]  -- highlight any instance of TODO  as an error
vim.cmd [[call matchadd('Error', 'FIXME', -1)]] -- highlight any instance of FIXME as an error

-- fugitive
-- delete fugitive buffers when they are left
vim.cmd [[
  augroup InitFugitive
    autocmd!
    autocmd BufReadPost fugitive://* set bufhidden=delete
  augroup END
]]
vim.env.GIT_SSH_COMMAND = 'ssh -o ControlPersist=no'
vim.api.nvim_set_keymap("n", "<leader>gs", ":Git<cr>",         {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gd", ":Gvdiffsplit<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<cr>",  {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gb", ":Git blame<cr>",   {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gl", ":Gclog<cr>",       {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gp", ":Git push<cr>",    {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gr", ":GRemove<cr>",     {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gw", ":Gwrite<cr>",      {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>ge", ":Gedit<cr>",       {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>g.", ":Gcd<cr>:pwd<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gu", ":Git pull<cr>",    {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gn", ":Git merge<cr>",   {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>gf", ":Git fetch<cr>",   {silent = true, noremap = true})

-- lightline
vim.cmd [[
  augroup InitLightline
    autocmd!
    autocmd User LspDiagnosticsChanged call lightline#update()
  augroup END
]]

vim.g['lightline#bufferline#show_number'] = 1
vim.g['lightline#bufferline#enable_devicons'] = 1
vim.g['lightline#bufferline#unicode_symbols'] = 1
vim.g['lightline#bufferline#filename_modifier'] = ':t'
vim.g['lightline#bufferline#unnamed'] = '[No Name]'

vim.g.lightline_readonly_filetypes = {'help', 'man', 'qf', 'taskreport', 'taskinfo'}
vim.g.lightline_filetype_mode_filetypes = {'help', 'man', 'qf', 'defx'}
vim.g.lightline_no_lineinfo_filetypes = {'taskreport', 'taskinfo', 'defx'}
vim.g.lightline_no_filetype_filetypes = {'man', 'help', 'qf', 'taskreport', 'taskinfo', 'defx'}
vim.g.lightline_no_filename_filetypes = {'qf', 'taskreport', 'taskinfo', 'defx'}

vim.g.lightline = {
  colorscheme = 'iceberg',
  separator = { left = "", right = "" },
  subseparator = { left = "", right = "" },
  active = {
    left = {
      { 'mode', 'crypt', 'paste', 'spell' },
      { 'filename' },
    },
    right = {
      { 'filetype', 'lineinfo' },
      { 'warnings', 'errors', 'git' },
    },
  },
  inactive = {
    left = {
      {},
      {},
      { 'fullfilename' },
    },
    right = {
      { 'filetype' },
    },
  },
  tabline = {
    left = {
      { 'buffers' },
    },
    right = {
      { 'lambda' },
    },
  },
  component = {
    lambda = 'λ',
  },
  component_function = {
      git          = 'rubix#lightline#git',
      filename     = 'rubix#lightline#filename',
      fullfilename = 'rubix#lightline#full_filename',
      filetype     = 'rubix#lightline#filetype',
      mode         = 'rubix#lightline#mode',
      crypt        = 'rubix#lightline#crypt',
      spell        = 'rubix#lightline#spell',
      paste        = 'rubix#lightline#paste',
  },
  component_expand = {
      lineinfo = 'rubix#lightline#line_info',
      errors   = 'rubix#lightline#errors',
      warnings = 'rubix#lightline#warnings',
      buffers  = 'lightline#bufferline#buffers',
  },
  component_type = {
      errors   = 'error',
      warnings = 'warning',
      buffers  = 'tabsel',
  },
  enable = {
    statusline = 1,
    tabline    = 1,
  },
}
