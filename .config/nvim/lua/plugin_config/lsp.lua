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
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
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
  pylsp = { -- https://github.com/nvim-lua/kickstart.nvim/issues/629
    filetypes = { 'python', 'py', 'ipy' },
    settings = {
      pylsp = {
        plugins = {
          -- formatter options (disabled for ruff)
          black = { enabled = false },
          pylsp_black = { enabled = false },
          autopep8 = { enabled = false },
          yapf = { enabled = false },
          -- linter options
          pylint = { enabled = false },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
          pydocstyle = { enabled = false },
          mccabe = { enabled = false }, -- complexity checker
          -- type checker
          pylsp_mypy = { enabled = false, live_mode = true, strict = false }, -- ???
          -- error checker
          flake8 = { enabled = false },
          -- auto-completion options
          jedi_completion = { fuzzy = true },
          -- import sorting
          pyls_isort = { enabled = false }, -- handled by ruff
          -- completions and renaming
          pylsp_rope = { enabled = true, rename = true },
          rope_completion = { enabled = true },
        },
      },
    },
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

-- Installed LSPs are configured and enabled automatically with mason-lspconfig
-- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
for server_name, config in pairs(servers) do
  vim.lsp.config(server_name, config)
end

-- NOTE: Some servers may require an old setup until they are updated. For the full list refer here: https://github.com/neovim/nvim-lspconfig/issues/3705
-- These servers will have to be manually set up with require("lspconfig").server_name.setup{}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
