local telescope = require('telescope')
local actions = require('telescope.actions')

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
    layout_config = {
      prompt_position = "top",
    },
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

    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
      }
    }
  }
}

telescope.load_extension('fzf')
telescope.load_extension('zoxide')

vim.api.nvim_set_keymap("n", "<c-b>",     "<cmd>Telescope buffers<cr>",     {silent = true})
vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>Telescope zoxide list<cr>", {silent = true})
