local luasnip = require 'luasnip'

if vim.g.blink_auto_trigger == nil then
  vim.g.blink_auto_trigger = true
end

-- Keep VS Code-style snippets available across languages.
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

require('blink.cmp').setup {
  keymap = {
    -- Change preset to match your preferred completion flow (see blink.cmp docs).
    preset = 'enter',
    -- Preserve the Tab-based select/snippet flow from the previous completion setup.
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<C-n>'] = { 'insert_next', 'fallback' },
    ['<C-p>'] = { 'insert_prev', 'fallback' },
  },
  completion = {
    trigger = {
      show_on_keyword = true,
      show_on_trigger_character = true,
      show_on_blocked_trigger_characters = function()
        if vim.bo.filetype == 'python' then
          return { '\n', '\t' }
        end
        return { ' ', '\n', '\t' }
      end,
    },
    menu = {
      auto_show = function()
        return vim.g.blink_auto_trigger and vim.bo.filetype ~= 'markdown'
      end,
      draw = {
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 150,
    },
  },
  snippets = { preset = 'luasnip' },
  sources = {
    -- Add 'buffer' if you want word completion from open buffers.
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      markdown = { 'buffer', 'path' },
    },
    providers = {
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
