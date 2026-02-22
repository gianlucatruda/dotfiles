local diagnostic_config = vim.diagnostic.config()
local diagnostics_enabled = vim.diagnostic.is_enabled()
local virtual_text_config = diagnostic_config.virtual_text
local virtual_text_enabled = virtual_text_config ~= false
local inlay_hints_enabled = true
if vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled then
  inlay_hints_enabled = vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
end
local ty_diagnostic_mode = 'openFilesOnly'
local lsp_ui_enabled = vim.diagnostic.is_enabled() and virtual_text_enabled and inlay_hints_enabled

local function refresh_lsp_ui_state()
  lsp_ui_enabled = vim.diagnostic.is_enabled() and virtual_text_enabled and inlay_hints_enabled
end

local function notify_toggle(label, enabled, command)
  local state = enabled and 'on' or 'off'
  vim.notify(string.format('%s: %s (%s)', label, state, command), vim.log.levels.INFO)
end

local function notify_info(message, command)
  vim.notify(string.format('%s (%s)', message, command), vim.log.levels.INFO)
end

local function notify_warn(message, command)
  vim.notify(string.format('%s (%s)', message, command), vim.log.levels.WARN)
end

if not vim.lsp.util._wrapped_make_position_params then
  local make_position_params = vim.lsp.util.make_position_params
  vim.lsp.util.make_position_params = function(win, position_encoding)
    if position_encoding == nil then
      local ty_client = vim.lsp.get_clients { bufnr = 0, name = 'ty' }
      if #ty_client > 0 then
        position_encoding = ty_client[1].offset_encoding
      else
        local clients = vim.lsp.get_clients { bufnr = 0 }
        if #clients > 0 then
          position_encoding = clients[1].offset_encoding
        end
      end
    end
    return make_position_params(win, position_encoding)
  end
  vim.lsp.util._wrapped_make_position_params = true
end

local function format_buffer(bufnr)
  if vim.bo[bufnr].filetype == 'markdown' then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd('silent! keepjumps normal! gggqG')
    end)
    return
  end

  vim.lsp.buf.format { bufnr = bufnr }
end

local function apply_inlay_hints(bufnr)
  if not vim.lsp.inlay_hint then
    notify_warn('Inlay hints not supported', 'vim.lsp.inlay_hint.enable(...)')
    return
  end

  vim.lsp.inlay_hint.enable(inlay_hints_enabled, { bufnr = bufnr })
end

local function apply_ty_settings(client)
  client.settings = client.settings or {}
  client.settings.ty = client.settings.ty or {}
  client.settings.ty.diagnosticMode = ty_diagnostic_mode
  client.notify('workspace/didChangeConfiguration', { settings = client.settings })
end

local function toggle_diagnostics()
  diagnostics_enabled = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(diagnostics_enabled)
  refresh_lsp_ui_state()
  notify_toggle('LSP diagnostics', diagnostics_enabled, string.format('vim.diagnostic.enable(%s)', diagnostics_enabled))
end

local function toggle_virtual_text()
  virtual_text_enabled = not virtual_text_enabled
  if virtual_text_enabled then
    vim.diagnostic.config { virtual_text = virtual_text_config ~= false and virtual_text_config or true }
  else
    vim.diagnostic.config { virtual_text = false }
  end
  refresh_lsp_ui_state()
  notify_toggle('LSP virtual text', virtual_text_enabled, string.format('vim.diagnostic.config({ virtual_text = %s })', virtual_text_enabled))
end

local function toggle_inlay_hints()
  if not vim.lsp.inlay_hint then
    notify_warn('Inlay hints not supported', 'vim.lsp.inlay_hint.enable(...)')
    return
  end

  inlay_hints_enabled = not inlay_hints_enabled
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not vim.tbl_isempty(vim.lsp.get_clients { bufnr = buf }) then
      vim.lsp.inlay_hint.enable(inlay_hints_enabled, { bufnr = buf })
    end
  end
  refresh_lsp_ui_state()
  notify_toggle('LSP inlay hints', inlay_hints_enabled, string.format('vim.lsp.inlay_hint.enable(%s)', inlay_hints_enabled))
end

local function toggle_ty_workspace_diagnostics()
  local clients = vim.lsp.get_clients { name = 'ty' }
  if vim.tbl_isempty(clients) then
    notify_warn('Ty LSP not attached', 'workspace/didChangeConfiguration')
    return
  end

  ty_diagnostic_mode = ty_diagnostic_mode == 'workspace' and 'openFilesOnly' or 'workspace'
  for _, client in ipairs(clients) do
    apply_ty_settings(client)
  end
  notify_info(string.format('Ty diagnostics: %s', ty_diagnostic_mode), string.format('ty.diagnosticMode=%s', ty_diagnostic_mode))
end

local function toggle_all_lsp_ui()
  local enable = not lsp_ui_enabled

  diagnostics_enabled = enable
  vim.diagnostic.enable(enable)

  virtual_text_enabled = enable
  if virtual_text_enabled then
    vim.diagnostic.config { virtual_text = virtual_text_config ~= false and virtual_text_config or true }
  else
    vim.diagnostic.config { virtual_text = false }
  end

  if vim.lsp.inlay_hint then
    inlay_hints_enabled = enable
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and not vim.tbl_isempty(vim.lsp.get_clients { bufnr = buf }) then
        vim.lsp.inlay_hint.enable(inlay_hints_enabled, { bufnr = buf })
      end
    end
  end

  local clients = vim.lsp.get_clients { name = 'ty' }
  ty_diagnostic_mode = enable and 'workspace' or 'openFilesOnly'
  if vim.tbl_isempty(clients) then
    notify_warn('Ty LSP not attached', 'workspace/didChangeConfiguration')
  else
    for _, client in ipairs(clients) do
      apply_ty_settings(client)
    end
  end

  lsp_ui_enabled = enable

  local summary = string.format(
    'LSP UI: diag=%s, vtext=%s, inlay=%s, ty=%s',
    enable and 'on' or 'off',
    virtual_text_enabled and 'on' or 'off',
    inlay_hints_enabled and 'on' or 'off',
    ty_diagnostic_mode
  )
  local command = string.format(
    'vim.diagnostic.enable(%s); vim.diagnostic.config({ virtual_text = %s }); vim.lsp.inlay_hint.enable(%s); ty.diagnosticMode=%s',
    enable,
    virtual_text_enabled,
    inlay_hints_enabled,
    ty_diagnostic_mode
  )
  notify_info(summary, command)
end

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
        show_line = false,
        trim_text = true,
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
    map('<leader>f', function()
      format_buffer(event.buf)
    end, '[F]ormat current buffer')

    vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
      format_buffer(event.buf)
    end, { desc = 'Format current buffer' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == 'ty' then
      apply_ty_settings(client)
    end
    apply_inlay_hints(event.buf)
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
  { '<leader>tl', group = '[T]oggle [L]SP' },
  { '<leader>tg', group = '[T]oggle [G]it' },
  { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
}

vim.keymap.set('n', '<leader>tld', toggle_diagnostics, { desc = '[T]oggle [L]SP [D]iagnostics' })
vim.keymap.set('n', '<leader>tlv', toggle_virtual_text, { desc = '[T]oggle [L]SP [V]irtual text' })
vim.keymap.set('n', '<leader>tli', toggle_inlay_hints, { desc = '[T]oggle [L]SP [I]nlay hints' })
vim.keymap.set('n', '<leader>tlw', toggle_ty_workspace_diagnostics, { desc = '[T]oggle [L]SP [W]orkspace diagnostics' })
vim.keymap.set('n', '<leader>tla', toggle_all_lsp_ui, { desc = '[T]oggle [L]SP [A]ll' })

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

local lsp_servers = vim.tbl_keys(servers or {})
if vim.fn.executable('go') == 0 then
  lsp_servers = without(lsp_servers, 'gopls')
end

require('mason-lspconfig').setup {
  ensure_installed = lsp_servers,
  automatic_enable = false,
}

local tools = vim.list_extend(vim.deepcopy(lsp_servers), { 'stylua', 'prettier' })
require('mason-tool-installer').setup { ensure_installed = tools }

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
  'uv.lock',
  'ruff.toml',
  '.ruff.toml',
  'ty.toml',
  '.venv',
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
      showSyntaxErrors = false,
    },
  },
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.declarationProvider = false
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.completionProvider = nil
    client.server_capabilities.signatureHelpProvider = nil
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.inlayHintProvider = false
  end,
})

vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = python_root_markers,
  single_file_support = true,
  settings = {
    ty = {
      diagnosticMode = ty_diagnostic_mode,
      completions = { autoImport = true },
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
      },
    },
  },
})

vim.lsp.enable(vim.tbl_keys(servers or {}))
