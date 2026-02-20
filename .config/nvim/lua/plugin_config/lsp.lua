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
  { '<leader>r', group = '[R]ename' },
  { '<leader>s', group = '[S]earch' },
  { '<leader>w', group = '[W]orkspace' },
  { '<leader>t', group = '[T]oggle' },
  { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
}

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()
local util = require 'lspconfig.util'

local function exists(path)
  return path and vim.uv.fs_stat(path) ~= nil
end

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

  return nil
end

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
    init_options = {
      settings = {
        -- Ruff language server settings go here
        lineLength = 100,
        lint = { enable = true, preview = true },
        format = { enable = true, preview = true },
      }
    }
  },
  ty = {
    filetypes = { 'python', 'py', 'ipy' },
    settings = {
      ty = {
        -- Keep ty as the primary Python language server.
        disableLanguageServices = false,
        diagnosticMode = 'openFilesOnly',
        completions = { autoImport = true },
      },
    },
    before_init = function(_, config)
      apply_python_env(config, config.root_dir)
    end,
    on_new_config = apply_python_env,
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
-- Ensure the servers and tools above are installed
require('mason-lspconfig').setup {
  automatic_enable = vim.tbl_keys(servers or {}),
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua', -- Used to format Lua code
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- blink.cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
capabilities.offsetEncoding = { 'utf-16' }

-- Installed LSPs are configured and enabled automatically with mason-lspconfig
-- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
for server_name, config in pairs(servers) do
  config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})

  if server_name == 'ruff' then
    config.capabilities.offsetEncoding = { 'utf-16' }

    local on_init = config.on_init
    config.on_init = function(client, ...)
      if on_init then
        on_init(client, ...)
      end
      client.offset_encoding = 'utf-16'
      client.server_capabilities.referencesProvider = false
    end

    local on_attach = config.on_attach
    config.on_attach = function(client, ...)
      if on_attach then
        on_attach(client, ...)
      end
      client.server_capabilities.referencesProvider = false
    end
  end

  vim.lsp.config(server_name, config)
end

-- NOTE: Some servers may require an old setup until they are updated. For the full list refer here: https://github.com/neovim/nvim-lspconfig/issues/3705
-- These servers will have to be manually set up with require("lspconfig").server_name.setup{}
