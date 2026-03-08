if not vim.g.dotfiles_is_ghostty then
  vim.cmd.colorscheme('default')
  return
end

require('tokyonight').setup({
  style = 'moon',
})

vim.cmd.colorscheme('tokyonight')
