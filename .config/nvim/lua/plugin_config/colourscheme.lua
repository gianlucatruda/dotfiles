if vim.g.dotfiles_use_ghostty_tokyonight then
  require('tokyonight').setup({
    style = 'moon',
  })

  vim.cmd.colorscheme('tokyonight')
  return
end

vim.cmd.colorscheme('default')
