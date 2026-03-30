-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`

local languages = {
  'bash',
  'c',
  'cpp',
  'go',
  'html',
  'javascript',
  'latex',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'rust',
  'svelte',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

require('nvim-treesitter').setup {}
require('nvim-treesitter').install(languages)

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
}

local ts_select = require('nvim-treesitter-textobjects.select')
vim.keymap.set({ 'x', 'o' }, 'aa', function()
  ts_select.select_textobject('@parameter.outer', 'textobjects')
end, { desc = '[A]round [A]rg' })
vim.keymap.set({ 'x', 'o' }, 'ia', function()
  ts_select.select_textobject('@parameter.inner', 'textobjects')
end, { desc = '[I]nner [A]rg' })
vim.keymap.set({ 'x', 'o' }, 'af', function()
  ts_select.select_textobject('@function.outer', 'textobjects')
end, { desc = '[A]round [F]unction' })
vim.keymap.set({ 'x', 'o' }, 'if', function()
  ts_select.select_textobject('@function.inner', 'textobjects')
end, { desc = '[I]nner [F]unction' })
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  ts_select.select_textobject('@class.outer', 'textobjects')
end, { desc = '[A]round [C]lass' })
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  ts_select.select_textobject('@class.inner', 'textobjects')
end, { desc = '[I]nner [C]lass' })

local ts_move = require('nvim-treesitter-textobjects.move')
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  ts_move.goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Next function start' })
vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
  ts_move.goto_next_start('@class.outer', 'textobjects')
end, { desc = 'Next class start' })
vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
  ts_move.goto_next_end('@function.outer', 'textobjects')
end, { desc = 'Next function end' })
vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
  ts_move.goto_next_end('@class.outer', 'textobjects')
end, { desc = 'Next class end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  ts_move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Prev function start' })
vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
  ts_move.goto_previous_start('@class.outer', 'textobjects')
end, { desc = 'Prev class start' })
vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
  ts_move.goto_previous_end('@function.outer', 'textobjects')
end, { desc = 'Prev function end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
  ts_move.goto_previous_end('@class.outer', 'textobjects')
end, { desc = 'Prev class end' })

local ts_swap = require('nvim-treesitter-textobjects.swap')
vim.keymap.set('n', '<leader>a', function()
  ts_swap.swap_next('@parameter.inner')
end, { desc = 'Swap arg next' })
vim.keymap.set('n', '<leader>A', function()
  ts_swap.swap_previous('@parameter.inner')
end, { desc = 'Swap arg prev' })
