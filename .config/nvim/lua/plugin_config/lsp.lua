-- LSP keymaps that attach per-buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', function()
      vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
    end, '[C]ode [A]ction')

    map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    map('gr', function()
      require('telescope.builtin').lsp_references {
        use_lsp_with = function(client, _method)
          return client.name ~= 'ruff'
        end,
      }
    end, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    map('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')
    map('<leader>f', vim.lsp.buf.format, '[F]ormat current buffer')

    vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end,
})

require('which-key').add {
  { '<leader>c', group = '[C]ode' },
  { '<leader>d', group = '[D]ocument' },
  { '<leader>g', group = '[G]it' },
  { '<leader>r', group = '[R]ename' },
  { '<leader>s', group = '[S]earch' },
  { '<leader>w', group = '[W]orkspace' },
  { '<leader>t', group = '[T]oggle' },
  { '<leader>tg', group = '[T]oggle [G]it' },
  { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
}

-- Prefer Mason binaries inside Neovim without replacing shell PATH.
local mason_bin = vim.fn.stdpath('data') .. '/mason/bin'
if vim.fn.isdirectory(mason_bin) == 1 then
  local sep = package.config:sub(1, 1) == '\\' and ';' or ':'
  vim.env.PATH = mason_bin .. sep .. (vim.env.PATH or '')
end

require('mason').setup()

local servers = {
  clangd = {},
  gopls = {},
  rust_analyzer = {},
  ts_ls = {},
  html = {},
  jsonls = {},
  marksman = {},
  lua_ls = {},
  ruff = {},
  ty = {},
}

local function without(list, value)
  return vim.tbl_filter(function(item)
    return item ~= value
  end, list)
end

local ensure_installed = vim.tbl_keys(servers or {})
if vim.fn.executable('go') == 0 then
  ensure_installed = without(ensure_installed, 'gopls')
end

require('mason-lspconfig').setup {
  ensure_installed = ensure_installed,
  automatic_enable = false,
}

vim.list_extend(ensure_installed, { 'stylua' })
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
vim.lsp.config('*', { capabilities = capabilities })

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
})

local python_root_markers = {
  'pyproject.toml',
  'setup.cfg',
  'setup.py',
  'requirements.txt',
  'Pipfile',
  'ruff.toml',
  '.ruff.toml',
  'ty.toml',
  '.git',
}

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = python_root_markers,
  single_file_support = true,
  init_options = {
    settings = {
      lint = { enable = true },
      format = { enable = true },
    },
  },
})

vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = python_root_markers,
  single_file_support = true,
})

vim.lsp.enable(vim.tbl_keys(servers or {}))
