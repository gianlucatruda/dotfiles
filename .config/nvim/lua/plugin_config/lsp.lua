local diagnostic_config = vim.diagnostic.config()
local virtual_text_config = diagnostic_config.virtual_text
local has_inlay_hints = vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable

local state = {
  virtual_text = virtual_text_config ~= false,
  inlay_hints = has_inlay_hints
    and vim.lsp.inlay_hint.is_enabled
    and vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
    or false,
  ty_diagnostic_mode = 'openFilesOnly',
}

local function notify(message, command, level)
  vim.notify(string.format('%s (%s)', message, command), level or vim.log.levels.INFO)
end

local function notify_toggle(label, enabled, command)
  notify(string.format('%s: %s', label, enabled and 'on' or 'off'), command)
end

local function notify_warn(message, command)
  notify(message, command, vim.log.levels.WARN)
end

if not vim.lsp.util._wrapped_make_position_params then
  local make_position_params = vim.lsp.util.make_position_params
  local function default_position_encoding()
    local ty_client = vim.lsp.get_clients { bufnr = 0, name = 'ty' }
    if #ty_client > 0 then
      return ty_client[1].offset_encoding
    end

    local clients = vim.lsp.get_clients { bufnr = 0 }
    return clients[1] and clients[1].offset_encoding or nil
  end

  -- Ty uses utf-16 offsets; default to the active client encoding when unset.
  vim.lsp.util.make_position_params = function(win, position_encoding)
    return make_position_params(win, position_encoding or default_position_encoding())
  end
  vim.lsp.util._wrapped_make_position_params = true
end

local function format_buffer(bufnr)
  if vim.bo[bufnr].filetype == 'markdown' then
    -- Keep Markdown formatting driven by formatprg (Prettier).
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd('silent! keepjumps normal! gggqG')
    end)
    return
  end

  vim.lsp.buf.format { bufnr = bufnr }
end

local function set_virtual_text(enabled)
  state.virtual_text = enabled
  if enabled then
    vim.diagnostic.config { virtual_text = virtual_text_config ~= false and virtual_text_config or true }
  else
    vim.diagnostic.config { virtual_text = false }
  end
end

local function set_inlay_hints(enabled, opts)
  if not has_inlay_hints then
    if not opts or opts.warn ~= false then
      notify_warn('Inlay hints not supported', 'vim.lsp.inlay_hint.enable(...)')
    end
    return false
  end

  state.inlay_hints = enabled
  if opts and opts.bufnr then
    if vim.api.nvim_buf_is_loaded(opts.bufnr) and not vim.tbl_isempty(vim.lsp.get_clients { bufnr = opts.bufnr }) then
      vim.lsp.inlay_hint.enable(enabled, { bufnr = opts.bufnr })
    end
    return true
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not vim.tbl_isempty(vim.lsp.get_clients { bufnr = buf }) then
      vim.lsp.inlay_hint.enable(enabled, { bufnr = buf })
    end
  end
  return true
end

local function apply_ty_settings(client)
  client.settings = client.settings or {}
  client.settings.ty = client.settings.ty or {}
  client.settings.ty.diagnosticMode = state.ty_diagnostic_mode
  client.notify('workspace/didChangeConfiguration', { settings = client.settings })
end

local function apply_ty_diagnostic_mode()
  local clients = vim.lsp.get_clients { name = 'ty' }
  if vim.tbl_isempty(clients) then
    return false
  end

  for _, client in ipairs(clients) do
    apply_ty_settings(client)
  end
  return true
end

local function lsp_ui_enabled()
  local inlay_ok = has_inlay_hints and state.inlay_hints or not has_inlay_hints
  return vim.diagnostic.is_enabled() and state.virtual_text and inlay_ok
end

local function toggle_diagnostics()
  local enabled = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(enabled)
  notify_toggle('LSP diagnostics', enabled, string.format('vim.diagnostic.enable(%s)', enabled))
end

local function toggle_virtual_text()
  set_virtual_text(not state.virtual_text)
  notify_toggle(
    'LSP virtual text',
    state.virtual_text,
    string.format('vim.diagnostic.config({ virtual_text = %s })', state.virtual_text)
  )
end

local function toggle_inlay_hints()
  local enabled = not state.inlay_hints
  if set_inlay_hints(enabled) then
    notify_toggle(
      'LSP inlay hints',
      state.inlay_hints,
      string.format('vim.lsp.inlay_hint.enable(%s)', state.inlay_hints)
    )
  end
end

local function toggle_ty_workspace_diagnostics()
  state.ty_diagnostic_mode = state.ty_diagnostic_mode == 'workspace' and 'openFilesOnly' or 'workspace'
  if not apply_ty_diagnostic_mode() then
    notify_warn('Ty LSP not attached', 'workspace/didChangeConfiguration')
    return
  end
  notify(
    string.format('Ty diagnostics: %s', state.ty_diagnostic_mode),
    string.format('ty.diagnosticMode=%s', state.ty_diagnostic_mode)
  )
end

local function toggle_all_lsp_ui()
  local enable = not lsp_ui_enabled()

  vim.diagnostic.enable(enable)
  set_virtual_text(enable)
  if has_inlay_hints then
    set_inlay_hints(enable, { warn = false })
  else
    state.inlay_hints = enable
  end

  state.ty_diagnostic_mode = enable and 'workspace' or 'openFilesOnly'
  if not apply_ty_diagnostic_mode() then
    notify_warn('Ty LSP not attached', 'workspace/didChangeConfiguration')
  end

  local inlay_state = has_inlay_hints and (state.inlay_hints and 'on' or 'off') or 'n/a'
  local inlay_command = has_inlay_hints
    and string.format('vim.lsp.inlay_hint.enable(%s)', state.inlay_hints)
    or 'inlay hints unavailable'
  local summary = string.format(
    'LSP UI: diag=%s, vtext=%s, inlay=%s, ty=%s',
    enable and 'on' or 'off',
    state.virtual_text and 'on' or 'off',
    inlay_state,
    state.ty_diagnostic_mode
  )
  local command = string.format(
    'vim.diagnostic.enable(%s); vim.diagnostic.config({ virtual_text = %s }); %s; ty.diagnosticMode=%s',
    enable,
    state.virtual_text,
    inlay_command,
    state.ty_diagnostic_mode
  )
  notify(summary, command)
end

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
    set_inlay_hints(state.inlay_hints, { bufnr = event.buf, warn = false })
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

-- Prefer Mason-managed binaries inside Neovim for consistent tool versions.
local mason_bin = vim.fn.stdpath('data') .. '/mason/bin'
if vim.fn.isdirectory(mason_bin) == 1 then
  local sep = package.config:sub(1, 1) == '\\' and ';' or ':'
  vim.env.PATH = mason_bin .. sep .. (vim.env.PATH or '')
end

require('mason').setup()

local servers = {
  'clangd',
  'rust_analyzer',
  'ts_ls',
  'html',
  'jsonls',
  'marksman',
  'lua_ls',
  'ruff',
  'ty',
}

require('mason-lspconfig').setup {
  ensure_installed = servers,
  automatic_enable = false,
}

require('mason-tool-installer').setup {
  ensure_installed = { 'stylua', 'prettier' },
}

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

-- Align Python roots with tool configs so Ruff and Ty agree on scope.
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

local function disable_ruff_language_features(client)
  -- Ruff stays lint/format-only so Ty owns language services.
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
end

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
  on_attach = disable_ruff_language_features,
})

vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = python_root_markers,
  single_file_support = true,
  settings = {
    ty = {
      diagnosticMode = state.ty_diagnostic_mode,
      completions = { autoImport = true },
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
      },
    },
  },
})

vim.lsp.enable(servers)
