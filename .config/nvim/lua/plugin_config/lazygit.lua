-- Lazygit integration
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'Open [L]azy[G]it' })

-- Auto-reload files after lazygit closes
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*lazygit*",
  callback = function()
    vim.cmd("checktime")
  end,
})
