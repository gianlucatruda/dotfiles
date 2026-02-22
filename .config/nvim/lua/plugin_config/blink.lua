local luasnip = require 'luasnip'

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
  },
  completion = {
    menu = {
      draw = {
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind' },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
    },
  },
  snippets = { preset = 'luasnip' },
  sources = {
    -- Add 'buffer' if you want word completion from open buffers.
    default = { 'lsp', 'path', 'snippets' },
  },
  signature = { enabled = true },
}
