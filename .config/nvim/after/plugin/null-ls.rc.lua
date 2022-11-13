local status, null_ls = pcall(require, 'null-ls')
if (not status) then return end

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
      vim.api.nvim_command [[augroup END]]

      -- format on save
      vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.format { async = true } ")
      -- format on \f
      vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.format { async = true } ")
    end
  end,

  sources = {
    null_ls.builtins.diagnostics.eslint_d.with({
      diagnostics_format = '[eslint] #{m}\n(#{c})'
    }),
    null_ls.builtins.diagnostics.fish
  }
})
