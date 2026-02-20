local luasnip = require 'luasnip'

-- Keep VS Code-style snippets available across languages.
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

require('blink.cmp').setup {
  keymap = {
    preset = 'enter',
    -- Preserve the Tab-based select/snippet flow from the previous completion setup.
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
  },
  snippets = { preset = 'luasnip' },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },
}
