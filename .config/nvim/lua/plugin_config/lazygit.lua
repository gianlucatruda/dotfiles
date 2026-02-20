-- Lazygit integration
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'Open [G]it UI (LazyGit)' })

-- Auto-reload files after lazygit closes
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*lazygit*",
  callback = function()
    vim.cmd("checktime")
  end,
})
