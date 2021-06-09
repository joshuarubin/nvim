local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local make_entry = require('telescope.make_entry')

local exists = function(table, key)
  for k, v in ipairs(table) do
    if k == key then
      return true
    end
  end

  return false
end

local buflisted = function()
  return vim.tbl_filter(function(val)
    if not vim.fn.buflisted(val) then
      return false
    end

    local ft = vim.fn.getbufvar(val, '&filetype')
    return not exists({'qf', 'man'}, ft)
  end, vim.fn.range(1, vim.fn.bufnr('$')))
end

local docdirs = nil

local is_doc_file = function(file)
  if docdirs == nil then
    docdirs = vim.tbl_map(function(val)
      return vim.fn.resolve(val .. '/doc')
    end, vim.split(vim.go.runtimepath, ','))
  end

  return vim.fn.index(docdirs, vim.fn.fnamemodify(file, ':p:h')) >= 0
end

local not_empty = function(list)
  return vim.tbl_filter(function(val)
    return not vim.fn.empty(val)
  end, list)
end

local filereadable = function(val)
  if vim.fn.filereadable(vim.fn.expand(val)) == 1 then return true end
  return false
end

local all_files = function()
  local files = vim.tbl_filter(function(val)
    return filereadable(val)
  end, vim.v.oldfiles)

  local listed = not_empty(vim.tbl_map(function(val)
    return vim.fn.resolve(vim.fn.fnamemodify(vim.fn.bufname(val), ':p'))
  end, buflisted()))

  files = vim.tbl_extend("keep", listed, files)

  -- filter out doc files
  files = vim.tbl_filter(function(val)
    return not is_doc_file(val)
  end, files)

  -- shorten the displayed filenames
  files = vim.tbl_map(function(val)
    return vim.fn.fnamemodify(val, ':~:.')
  end, files)

  return files
end

local telescope = {}

telescope.history = function(opts)
  pickers.new(opts, {
    prompt_title = 'History',
    finder = finders.new_table {
      results = all_files(),
      entry_maker = make_entry.gen_from_file(opts),
    },
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

return telescope
