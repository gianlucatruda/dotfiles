require('oil').setup {
  -- Keep netrw as the default to avoid changing long-lived habits.
  -- Set to true if you want Oil to fully replace netrw.
  default_file_explorer = false,
}

-- Mnemonic entry point, with a standard fallback for fast parent navigation.
vim.keymap.set('n', '<leader>o', function()
  require('oil').open()
end, { desc = '[O]il file explorer' })

-- '-' mirrors the netrw parent directory shortcut for muscle memory.
vim.keymap.set('n', '-', function()
  require('oil').open()
end, { desc = 'Oil: open parent directory' })
