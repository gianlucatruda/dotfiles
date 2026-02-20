--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', function()
      vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
    end, '[C]ode [A]ction')

    -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition') -- Uses deprecated LSP API
    map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    map('gr', function()
      require('telescope.builtin').lsp_references {
        -- Ruff occasionally reports references capability; skip it to avoid errors
        use_lsp_with = function(client, _method)
          return client.name ~= 'ruff'
        end,
      }
    end, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    map('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')
    map('<leader>f', vim.lsp.buf.format, '[F]ormat current buffer')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end
})

-- document existing key chains
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

-- LSP UI toggles keep noisy diagnostics optional for quick edits.
-- Flip these defaults if you prefer a quieter startup.
local diagnostics_enabled = true
-- Preserve the initial virtual_text config so the toggle restores table settings.
local virtual_text_config = vim.diagnostic.config().virtual_text
local virtual_text_enabled = virtual_text_config ~= false
-- Ty workspace checks are heavier; toggle on when you need full-project coverage.
local ty_workspace_checks = false

-- 'openFilesOnly' is faster; 'workspace' is slower but more complete.
local function ty_diagnostic_mode()
  return ty_workspace_checks and 'workspace' or 'openFilesOnly'
end

local function set_virtual_text(enabled)
  if enabled then
    -- Restore any custom virtual_text table when re-enabling.
    vim.diagnostic.config { virtual_text = virtual_text_config == false and true or virtual_text_config }
  else
    vim.diagnostic.config { virtual_text = false }
  end
end

local function set_inlay_hints(bufnr, enabled)
  -- Handle Neovim API signature changes without breaking the toggle.
  if not vim.lsp.inlay_hint then
    return
  end

  local ok = pcall(vim.lsp.inlay_hint.enable, enabled, { bufnr = bufnr })
  if ok then
    return
  end
  pcall(vim.lsp.inlay_hint.enable, bufnr, enabled)
end

local function inlay_hints_enabled(bufnr)
  if vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled then
    local ok, enabled = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
    if ok then
      return enabled
    end
    ok, enabled = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
    if ok then
      return enabled
    end
  end

  return vim.b.lsp_inlay_hints_enabled == true
end

vim.keymap.set('n', '<leader>td', function()
  diagnostics_enabled = not diagnostics_enabled
  if diagnostics_enabled then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end, { desc = '[T]oggle [D]iagnostics' })

vim.keymap.set('n', '<leader>tv', function()
  virtual_text_enabled = not virtual_text_enabled
  set_virtual_text(virtual_text_enabled)
end, { desc = '[T]oggle [V]irtual text' })

vim.keymap.set('n', '<leader>th', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = inlay_hints_enabled(bufnr)
  set_inlay_hints(bufnr, not enabled)
  vim.b.lsp_inlay_hints_enabled = not enabled
end, { desc = '[T]oggle Inlay [H]ints' })

vim.keymap.set('n', '<leader>tt', function()
  ty_workspace_checks = not ty_workspace_checks
  local mode = ty_diagnostic_mode()
  for _, client in ipairs(vim.lsp.get_clients { name = 'ty' }) do
    client.config.settings = client.config.settings or {}
    client.config.settings.ty = client.config.settings.ty or {}
    client.config.settings.ty.diagnosticMode = mode
    client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end
end, { desc = '[T]oggle [T]y workspace checks' })

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()
local util = require 'lspconfig.util'

local function exists(path)
  return path and vim.uv.fs_stat(path) ~= nil
end

-- Scan upward for common venv names; add more if your projects differ.
local function find_venv(startpath)
  local function scan(path)
    if not path then
      return nil, nil
    end

    for _, name in ipairs { '.venv', 'venv' } do
      local venv = util.path.join(path, name)
      local python = util.path.join(venv, 'bin', 'python')
      if exists(python) then
        return python, venv
      end
    end

    local parent = util.path.dirname(path)
    if not parent or parent == path then
      return nil, nil
    end
    return scan(parent)
  end

  return scan(startpath)
end

local function get_venv(root_dir)
  local _, venv = find_venv(root_dir or vim.fn.getcwd())
  if venv then
    return venv
  end

  -- If Neovim is already running inside a venv, prefer it.
  if vim.env.VIRTUAL_ENV then
    local venv_python = util.path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    if exists(venv_python) then
      return vim.env.VIRTUAL_ENV
    end
  end

  -- If you use conda, consider checking CONDA_PREFIX here.

  return nil
end

-- Ensure language servers see the same venv as the active project.
local function apply_python_env(new_config, root_dir)
  local venv = get_venv(root_dir)
  if not venv then
    return
  end

  -- Ensure language servers see the same environment as the active project.
  new_config.cmd_env = new_config.cmd_env or {}
  new_config.cmd_env.VIRTUAL_ENV = venv
  local venv_bin = util.path.join(venv, 'bin')
  new_config.cmd_env.PATH = venv_bin .. ':' .. (vim.env.PATH or '')
end

-- Root markers define where Python projects start; order matters (closest wins).
-- Add/remove markers to match your own project layout.
local python_root_markers = {
  'pyproject.toml',
  'setup.cfg',
  'setup.py',
  'requirements.txt',
  'Pipfile',
  'ruff.toml',
  '.venv',
  'venv',
}

local python_rooter = util.root_pattern(unpack(python_root_markers))

local function python_root_dir(fname)
  -- Prefer the closest Python root so subprojects pick the right venv/config.
  return python_rooter(fname) or util.path.dirname(fname)
end

local function disable_ruff_language_services(client)
  -- Ruff stays lint/format-only; ty owns language services to avoid mixed results.
  -- Remove this if you want Ruff for go-to/rename and disable ty language services.
  client.server_capabilities.hoverProvider = false
  client.server_capabilities.definitionProvider = false
  client.server_capabilities.declarationProvider = false
  client.server_capabilities.implementationProvider = false
  client.server_capabilities.typeDefinitionProvider = false
  client.server_capabilities.referencesProvider = false
  client.server_capabilities.documentSymbolProvider = false
  client.server_capabilities.workspaceSymbolProvider = false
  client.server_capabilities.renameProvider = false
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
local servers = {
  rust_analyzer = { filetypes = { 'rust', 'rs' } },
  ts_ls = { filetypes = { 'javascript', 'jsx', 'typescript', 'svelte' } },
  jsonls = { filetypes = { 'json' } },
  clangd = {},
  ruff = {
    filetypes = { 'python', 'py', 'ipy' },
    root_dir = python_root_dir,
    init_options = {
      settings = {
        -- Ruff language server settings go here
        -- Keep this aligned with your formatter (e.g., 88 for Black).
        lineLength = 100,
        -- preview enables experimental rules; set false for stable behavior.
        lint = { enable = true, preview = true },
        format = { enable = true, preview = true },
      }
    },
    before_init = function(_, config)
      apply_python_env(config, config.root_dir)
    end,
    on_new_config = apply_python_env,
  },
  ty = {
    filetypes = { 'python', 'py', 'ipy' },
    root_dir = python_root_dir,
    settings = {
      ty = {
        -- Keep ty as the primary Python language server.
        -- Set true if you want Ruff (or another server) to own language services.
        disableLanguageServices = false,
        -- diagnosticMode options: 'openFilesOnly' (fast) or 'workspace' (full).
        diagnosticMode = ty_diagnostic_mode(),
        -- autoImport = false if you want manual import control.
        completions = { autoImport = true },
      },
    },
    before_init = function(_, config)
      apply_python_env(config, config.root_dir)
      config.settings = config.settings or {}
      config.settings.ty = config.settings.ty or {}
      config.settings.ty.diagnosticMode = ty_diagnostic_mode()
    end,
    on_new_config = function(new_config, _)
      apply_python_env(new_config, new_config.root_dir)
      new_config.settings = new_config.settings or {}
      new_config.settings.ty = new_config.settings.ty or {}
      new_config.settings.ty.diagnosticMode = ty_diagnostic_mode()
    end,
  },
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
}


-- Updated Mason setup from https://github.com/nvim-lua/kickstart.nvim/pull/1475/files
-- Ensure the servers and tools above are installed.
require('mason-lspconfig').setup {
  -- Set to false if you prefer to enable servers manually.
  automatic_enable = vim.tbl_keys(servers or {}),
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua', -- Used to format Lua code
})
-- Add/remove tools here if you want Mason to keep them in sync.
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- blink.cmp supports additional completion capabilities, so broadcast that to servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
-- Ruff expects utf-16 offsets; scope this to Ruff if other servers complain.
capabilities.offsetEncoding = { 'utf-16' }

-- Installed LSPs are configured and enabled automatically with mason-lspconfig.
-- The loop below overrides defaults with the configs in the servers table.
-- Neovim 0.11+ uses vim.lsp.config; on older versions use lspconfig.setup().
for server_name, config in pairs(servers) do
  config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})

  if server_name == 'ruff' then
    -- Ruff expects utf-16 offsets; keep explicit to avoid position mismatches.
    config.capabilities.offsetEncoding = { 'utf-16' }

    local on_init = config.on_init
    config.on_init = function(client, ...)
      if on_init then
        on_init(client, ...)
      end
      client.offset_encoding = 'utf-16'
      disable_ruff_language_services(client)
    end

    local on_attach = config.on_attach
    config.on_attach = function(client, ...)
      if on_attach then
        on_attach(client, ...)
      end
      disable_ruff_language_services(client)
    end
  end

  vim.lsp.config(server_name, config)
end

-- NOTE: Some servers may require an old setup until they are updated. For the full list refer here: https://github.com/neovim/nvim-lspconfig/issues/3705
-- These servers will have to be manually set up with require("lspconfig").server_name.setup{}
