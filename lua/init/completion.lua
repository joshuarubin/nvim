require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1

  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      return true
  end

  return false
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<c-n>"
  end

  if vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<plug>(vsnip-expand-or-jump)"
  end

  if check_back_space() then
    return t "<tab>"
  end

  return vim.fn['compe#complete']()
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<c-p>"
  end

  if vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<plug>(vsnip-jump-prev)"
  end

  return t "<c-h>"
end

_G.cr_complete = function()
  local expandable = vim.fn["vsnip#expandable"]() == 1

  -- if the popup menu is visible
  if vim.fn.pumvisible() == 1 then
    local not_selected = vim.fn.complete_info({'selected'}).selected == -1

    -- nothing is selected in the popup menu, but the entered text is an
    -- expandable snippet
    if not_selected then
      if expandable then
        return t "<plug>(vsnip-expand)"
      end

      return vim.fn['compe#close']()
    end

    -- normal completion
    return vim.fn['compe#confirm']()
  end

  -- there's no popup, but the entered text is an expandable snippet
  if expandable then
    return t "<plug>(vsnip-expand)"
  end

  -- fallback to a normal `<cr>`, but since this mapping allows remapping, we
  -- use feedkeys with the argument not to remap it, so we don't enter an
  -- infinite loop
  -- ok, so this isn't a "normal `<cr>`", it's been modified to use the endwise
  -- plugin. endwise has to have its default mappings disabled because otherwise
  -- it breaks everything. so we can't use `<plug>DiscretionaryEnd` either. so
  -- we'll use the EndwiseDiscretionary() func, but that has to be inserted into
  -- the expression register with `<c-r>=` and followed by `<cr>`. normally this
  -- would be enough, but for some reason we also need to add an undo point with
  -- `<c-g>u<cr>` or else this doesn't work at all.

  vim.fn.feedkeys(break_undo())
  vim.fn.feedkeys(t "<cr>", "n") -- this has to be run with `noremap` to prevent infinite loop
  vim.fn.feedkeys(t "<plug>Endwise")

  return t "<ignore>"
end

break_undo = function()
  return t "<c-g>u"
end

insert_expression = function(value)
  return t "<c-r>=" .. value .. t "<cr>"
end

vim.api.nvim_set_keymap("i", "<tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<s-tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<s-tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<cr>", "v:lua.cr_complete()", {expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<plug>Endwise", insert_expression("EndwiseDiscretionary()"), {silent = true, noremap = true})
vim.api.nvim_set_keymap("i", "<c-e>", "compe#close('<c-e>')", {expr = true, silent = true})
