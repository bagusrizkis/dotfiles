local status, lsp_signature = pcall(require, 'lsp_signature')
if (not status) then return end

lsp_signature.setup({
  bind = true,
  handler_opts = {
    border = 'rounded'
  },
  always_trigger = false,
  toggle_key = '<C-k>',
  floating_window_above_cur_line = true
})
