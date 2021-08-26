local lspconfig = require('lspconfig')
local rust = require('rust-tools')
local ts_utils = require('nvim-lsp-ts-utils')
local null_ls = require("null-ls")

vim.cmd [[sign define LspDiagnosticsSignError       text= texthl=LspDiagnosticsSignError       linehl= numhl=]]
vim.cmd [[sign define LspDiagnosticsSignWarning     text= texthl=LspDiagnosticsSignWarning     linehl= numhl=]]
vim.cmd [[sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=]]
vim.cmd [[sign define LspDiagnosticsSignHint        text= texthl=LspDiagnosticsSignHint        linehl= numhl=]]

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

vim.lsp.handlers["textDocument/codeLens"] = function(err, _, result, client_id, bufnr)
  -- ignore this error since it shows up for the codelens.refresh() autocmd and
  -- is very annoying
  -- method textDocument/codeLens is not supported by any of the servers registered for the current buffer
  if err and err.code == -32601 then
    return
  end

  return vim.lsp.codelens.on_codelens(err, _, result, client_id, bufnr)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  if filetype == "go" then
    vim.api.nvim_command[[autocmd BufWritePre <buffer> lua go_organize_imports()]]
  else
    vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
  end

  vim.api.nvim_command[[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap('n', '<leader>l', '<cmd>lua vim.lsp.codelens.run()<cr>', opts)
end

_G.go_organize_imports = function(timeout_ms)
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, 't', true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local method = "textDocument/codeAction"
  local result = vim.lsp.buf_request_sync(0, method, params, timeout_ms)
  if not result then return end

  if result then
    for _, v in ipairs(result) do
      local result = v.result
      if result and result[1] then
        local edit = result[1].edit
        vim.lsp.util.apply_workspace_edit(edit)
      end
    end
  end

  vim.lsp.buf.formatting_seq_sync()
end

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      buildFlags = {'-tags=wireinject'},
      experimentalTemplateSupport = true,
      usePlaceholders = true,
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
        nilness = true,
      },
      analyses = {
        fillreturns = true,
        nonewvars = true,
        shadow = true,
        undeclaredname = true,
        unreachable = true,
        unusedparams = true,
        unusedwrite = true,
      },
      gofumpt = true,
      ["local"] = 'go.ngrok.com',
      staticcheck = true,
    }
  },
  flags = {
    debounce_text_changes = 200,
  },
}

null_ls.setup {}

lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    -- disable tsserver formatting (done by null-ls)
    client.resolved_capabilities.document_formatting = false

    ts_utils.setup {
      debug = false,
      disable_commands = false,
      enable_import_on_completion = false,

      -- eslint
      eslint_enable_code_actions = true,
      eslint_enable_disable_comments = true,
      eslint_bin = "eslint_d",
      eslint_config_fallback = nil,
      eslint_enable_diagnostics = true,

      -- formatting
      enable_formatting = true,
      formatter = "eslint_d",
      formatter_config_fallback = nil,

      -- parentheses completion
      complete_parens = false,
      signature_help_in_parens = false,

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil,
    }

    ts_utils.setup_client(client)

    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "clangd", "cmake" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

rust.setup {
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
}
