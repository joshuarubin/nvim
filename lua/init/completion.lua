local cmp = require('cmp')
local types = require('cmp.types')

cmp.setup {
  preselect = types.cmp.PreselectMode.None,
  sources = {
    { name = 'path' },
    { name = 'buffer' },
    { name = 'calc' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'vsnip' },
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end
  },
  mapping = {
    ['<c-p>'] = cmp.mapping.select_prev_item(),
    ['<c-n>'] = cmp.mapping.select_next_item(),
    ['<c-d>'] = cmp.mapping.scroll_docs(-4),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-space>'] = cmp.mapping.complete(),
    ['<c-e>'] = cmp.mapping.close(),
    ['<cr>'] = cmp.mapping(function(fallback)
      local expandable = vim.fn["vsnip#expandable"]() == 1

      -- if the popup menu is visible
      if vim.fn.pumvisible() == 1 then
        local not_selected = vim.fn.complete_info({'selected'}).selected == -1

        -- nothing is selected in the popup menu, but the entered text is an expandable snippet
        if not_selected then
          if expandable then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<plug>(vsnip-expand)', true, true, true))
          else
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<c-e>', true, true, true)) -- close cmp
          end
        else -- normal completion
          cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace})(fallback)
        end
      elseif expandable then -- there's no popup, but the entered text is an expandable snippet
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<plug>(vsnip-expand)', true, true, true))
      else
        fallback() -- fallback to a normal `<cr>`
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<plug>Endwise", true, true, true))
      end
    end, {'i'}),
    ['<tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<c-n>', true, true, true), 'n')
      elseif vim.fn['vsnip#available']() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<plug>(vsnip-expand-or-jump)', true, true, true))
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<s-tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<c-p>', true, true, true), 'n')
      elseif vim.fn['vsnip#jumpable']() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<plug>(vsnip-jump-prev)', true, true, true))
      else
        fallback()
      end
    end, {'i', 's'}),
  },
}

vim.api.nvim_set_keymap("i", "<plug>Endwise", vim.api.nvim_replace_termcodes("<c-r>=EndwiseDiscretionary()<cr>", true, true, true), {silent = true, noremap = true})
