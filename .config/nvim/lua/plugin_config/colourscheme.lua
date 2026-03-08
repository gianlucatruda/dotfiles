local terminal = require('core.terminal')

if not terminal.is_ghostty() then
  return
end

require('tokyonight').setup({
  style = 'moon',
})

vim.cmd.colorscheme('tokyonight')
