vim.diagnostic.config({
	update_in_insert = true,
})

vim.cmd([[sign define DiagnosticSignError text= texthl=LspDiagnosticsSignError       linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn  text= texthl=LspDiagnosticsSignWarning     linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo  text= texthl=LspDiagnosticsSignInformation linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint  text= texthl=LspDiagnosticsSignHint        linehl= numhl=]])
