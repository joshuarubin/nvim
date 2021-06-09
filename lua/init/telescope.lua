local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local dir = require('rubix/dir')
local rubix = require('rubix/telescope')

telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--with-filename',
      '--no-heading',
      '--line-number',
      '--column',
      '--hidden',
      '--smart-case',
      '--follow',
      '--color=never',
    },
    prompt_position = "top",
    sorting_strategy = "ascending",
    set_env = { ['COLORTERM'] = 'truecolor' },

    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<c-j>"] = actions.move_selection_next,
        ["<c-k>"] = actions.move_selection_previous,
      },

      n = {
        ["<c-j>"] = actions.move_selection_next,
        ["<c-k>"] = actions.move_selection_previous,
      },
    },
  }
}

_G.rubix_find_files = function()
  builtin.find_files{
    find_command = { 'rg', '--files', '--hidden' },
    cwd = dir.project()
  }
end

_G.rubix_grep_string = function()
  builtin.grep_string{
    cwd = dir.project()
  }
end

_G.rubix_live_grep = function()
  builtin.live_grep{
    cwd = dir.project()
  }
end

_G.rubix_history = function()
  rubix.history{}
end

vim.api.nvim_set_keymap("n", "<c-p>",      ":lua rubix_find_files()<cr>",  {silent = true})
vim.api.nvim_set_keymap("n", "<c-b>",      "<cmd>Telescope buffers<cr>",   {silent = true})
vim.api.nvim_set_keymap("n", "<c-f>",      ":lua rubix_history()<cr>",     {silent = true})
vim.api.nvim_set_keymap("n", "<c-s><c-s>", ":lua rubix_grep_string()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<c-s><c-d>", ":lua rubix_live_grep()<cr>",   {silent = true})

vim.api.nvim_set_keymap("t", "<c-p>", "terminal#save_mode() . ':lua rubix_find_files()<cr>'", {silent = true, expr = true})
vim.api.nvim_set_keymap("t", "<c-b>", "terminal#save_mode() . '<cmd>Telescope buffers<cr>'",  {silent = true, expr = true})
