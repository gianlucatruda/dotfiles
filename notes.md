- [ ] **Git Integration**
  - [x] `tpope/vim-fugitive`
  - [x] `tpope/vim-rhubarb`

- [ ] **Automatic Indentation Detection**
  - [x] `tpope/vim-sleuth`

- [ ] **Language Server Protocol (LSP) Integration**
  - [x] `neovim/nvim-lspconfig`
  - [x] `williamboman/mason.nvim`
  - [x] `williamboman/mason-lspconfig.nvim`
  - [x] `j-hui/fidget.nvim`
  - [x] `folke/neodev.nvim`

- [ ] **Autocompletion**
  - [x] `hrsh7th/nvim-cmp`
  - [x] `L3MON4D3/LuaSnip`
  - [x] `saadparwaiz1/cmp_luasnip`
  - [x] `hrsh7th/cmp-nvim-lsp`
  - [x] `hrsh7th/cmp-path`
  - [x] `rafamadriz/friendly-snippets`

- [ ] **Utility Tools**
  - [x] `folke/which-key.nvim`
  - [x] `lewis6991/gitsigns.nvim`
  - [x] `numToStr/Comment.nvim`
  - [x] `lukas-reineke/indent-blankline.nvim`
  - [x] `smithbm2316/centerpad.nvim`
  - [x] `supermaven-inc/supermaven-nvim`
  - [x] `yacineMTB/dingllm.nvim`

- [ ] **Visual Presentation and User Interface**
  - [x] `EdenEast/nightfox.nvim`
  - [x] `nvim-lualine/lualine.nvim`

- [ ] **Editor Enhancements**
  - [x] `nvim-telescope/telescope.nvim`
  - [x] `nvim-telescope/telescope-fzf-native.nvim`
  - [x] `nvim-lua/plenary.nvim`
  - [x] `nvim-treesitter/nvim-treesitter`
  - [x] `nvim-treesitter/nvim-treesitter-textobjects`

```lua
-- Gianluca's custom keymaps --------------------------------------------------------

-- Visual mode: move selected lines up and down with J and K (i.e. shift+j and shift+k)
-- (adapted from ThePrimeagen: https://www.youtube.com/watch?v=w7i4amO_zaE)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
-- Insert current date in yyyy-mm-dd format
vim.keymap.set('n', '<leader>id', function()
  vim.cmd("r!date +\\%F")
end, { desc = '[I]nsert current [D]ate' })
-- Centerpad the buffer
vim.keymap.set('n', '<leader>z', '<cmd>Centerpad<cr>')

-- Gianluca's custom tab settings (vim-sleuth will override in some contexts?) -----
-- Note: these are similar to my defaults in .vimrc for vanilla vim (good baseline)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

```

```lua
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      require('nightfox').setup {
        -- Options
      }
      require('nightfox').load()
    end,
  },
```

```lua

  -- Centerpad a single buffer
  {
    'smithbm2316/centerpad.nvim',
  },
  {
    "supermaven-inc/supermaven-nvim",
    cmd = {
      -- Prevent autostart: https://github.com/supermaven-inc/supermaven-nvim/issues/81#issuecomment-2308891882
      "SupermavenStart",
    },
    opts = {},
  },
  {
    'yacineMTB/dingllm.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local system_prompt =
      'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks'
      local helpful_prompt = 'You are a helpful assistant. What I have sent are my notes so far.'
      local dingllm = require 'dingllm'

      local function openai_replace()
        dingllm.invoke_llm_and_stream_into_editor({
          url = 'https://api.openai.com/v1/chat/completions',
          model = 'gpt-4o',
          api_key_name = 'OPENAI_API_KEY',
          system_prompt = system_prompt,
          replace = true,
        }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
      end

      local function openai_help()
        dingllm.invoke_llm_and_stream_into_editor({
          url = 'https://api.openai.com/v1/chat/completions',
          model = 'gpt-4o',
          api_key_name = 'OPENAI_API_KEY',
          system_prompt = helpful_prompt,
          replace = false,
        }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
      end
      vim.keymap.set({ 'n', 'v' }, '<leader>L', openai_help, { desc = '[L]LM OpenAI (helpful)' })
      vim.keymap.set({ 'n', 'v' }, '<leader>l', openai_replace, { desc = '[L]LM OpenAI (terse)' })
    end,
  },

```

```lua

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()
local util = require 'lspconfig.util'
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  rust_analyzer = { filetypes = { 'rust', 'rs' } },
  ts_ls = { filetypes = { 'javascript', 'jsx', 'typescript', 'svelte' } },
  jsonls = { filetypes = { 'json' } },
  clangd = {},
  pylsp = { -- https://vi.stackexchange.com/questions/39765/how-to-configure-pylsp-when-using-mason-and-mason-lspconfig-in-neovim
    pylsp = {
      plugins = {
        -- formatter options
        black = { enabled = false },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        ruff = {                -- https://github.com/python-lsp/python-lsp-ruff
          enabled = true,       -- Enable the plugin
          formatEnabled = true, -- Enable formatting using ruffs formatter
          executable = "ruff",  -- Custom path to ruff
        },
        -- linter options
        pylint = { enabled = false },
        pyflakes = { enabled = true },
        pycodestyle = { enabled = true },
        pydocstyle = { enabled = false },
        maccabe = { enabled = true }, -- complexity checker
        -- type checker
        pylsp_mypy = { enabled = true, live_mode = true, strict = false },
        -- error checker
        flake8 = { enabled = true },
        -- auto-completion options
        jedi_completion = { fuzzy = true },
        -- import sorting
        pyls_isort = { enabled = true },
        -- completions and renaming
        pylsp_rope = { enabled = true, rename = true },
        rope_completion = { enabled = true },
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
```
