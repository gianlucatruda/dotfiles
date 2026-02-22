local luasnip = require 'luasnip'

if vim.g.blink_auto_trigger == nil then
  vim.g.blink_auto_trigger = true
end

-- Keep VS Code-style snippets available across languages.
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

require('blink.cmp').setup {
  keymap = {
    preset = 'enter',
    -- Preserve the Tab-based select/snippet flow from the previous completion setup.
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<C-n>'] = { 'insert_next', 'fallback' },
    ['<C-p>'] = { 'insert_prev', 'fallback' },
  },
  completion = {
    menu = {
      auto_show = function()
        return vim.g.blink_auto_trigger
      end,
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 150,
    },
  },
  snippets = { preset = 'luasnip' },
  sources = {
    providers = {
      -- Keep LSP results dominant to reduce noisy path/buffer matches.
      lsp = { fallbacks = {}, score_offset = 15 },
      path = { score_offset = -5 },
      snippets = { score_offset = -8 },
      buffer = { score_offset = -12 },
    },
  },
  signature = { enabled = true },
}

local function toggle_blink_auto_trigger()
  vim.g.blink_auto_trigger = not vim.g.blink_auto_trigger
  local state = vim.g.blink_auto_trigger and 'on' or 'off'
  vim.notify(
    string.format('Blink auto-trigger: %s (vim.g.blink_auto_trigger = %s)', state, vim.g.blink_auto_trigger),
    vim.log.levels.INFO
  )
end

vim.keymap.set('n', '<leader>tc', toggle_blink_auto_trigger, { desc = '[T]oggle [C]ompletion auto-trigger' })
