local is_directory = function(path)
  return vim.fn.isdirectory(path) == 1
end

local filereadable = function(path)
  return vim.fn.filereadable(path) == 1
end

local path_to_dir = function(path)
  if is_directory(path) then
    return path
  end

  return vim.fn.fnamemodify(path, ':p:h')
end

local bufdir = function(bufnr)
  -- if buffer is a terminal, return its cwd
  if vim.fn.getbufvar(bufnr, '&buftype') == 'terminal' then
    return vim.fn.getcwd(vim.fn.bufwinnr(bufnr))
  end

  return path_to_dir(vim.fn.bufname(bufnr))
end

local git_directory = function(path)
  local parent = path
  while true do
    path = parent .. '/.git'

    if is_directory(path) or filereadable(path) then
      return parent
    end

    local next = vim.fn.fnamemodify(parent, ':h')
    if next == parent then
      return ''
    end

    parent = next
  end
end

local escape_file_searching = function(buffer_name)
  return vim.fn.escape(buffer_name, '*[]?{}, ')
end

local parent_dir = function(path)
  local parent = path

  while true do
    if parent == vim.fn.getcwd() then
      return parent
    end

    local next = vim.fn.fnamemodify(parent, ':h')
    if next == parent then
      return ''
    end

    parent = next
  end
end

local path_to_project_dir = function(path, allow_empty)
  allow_empty = allow_empty or false
  local search_directory = path_to_dir(path)

  -- Search Git directory.
  local directory = git_directory(search_directory)

  -- Search project file.
  if directory == '' then
    local root_files = {
      'build.xml', 'prj.el', '.project', 'pom.xml', 'package.json',
      'Makefile', 'configure', 'Rakefile', 'NAnt.build',
      'P4CONFIG', 'tags', 'gtags'}

    local escaped_dir = escape_file_searching(search_directory)
    for _, d in ipairs(root_files) do
      d = vim.fn.findfile(d, escaped_dir .. ';')
      if d ~= '' then
        directory = vim.fn.fnamemodify(d, ':p:h')
        break
      end
    end
  end

  -- Search /src/ directory.
  if directory == '' then
    local base = search_directory

    -- regexp, match case
    local match = vim.regex("\\C/src/"):match_str(base)
    if match then
      directory = string.sub(base, 0, match+5)
    end
  end

  -- if :pwd is parent of a:path, use that
  if directory == '' then
    directory = parent_dir(search_directory)
  end

  -- Use original path.
  if directory == '' and not allow_empty then
    directory = search_directory
  end

  return directory
end

local dir = {}

dir.buffer = function()
  return bufdir(vim.fn.bufnr('%'))
end

dir.project = function()
  return path_to_project_dir(dir.buffer())
end

return dir
