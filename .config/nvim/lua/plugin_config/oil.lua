require('oil').setup {
  -- Keep netrw as the default to avoid changing long-lived habits.
  default_file_explorer = false,
}

-- Mnemonic entry point, with a standard fallback for fast parent navigation.
vim.keymap.set('n', '<leader>o', function()
  require('oil').open()
end, { desc = '[O]il file explorer' })

vim.keymap.set('n', '-', function()
  require('oil').open()
end, { desc = 'Oil: open parent directory' })
