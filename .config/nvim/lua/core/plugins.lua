require('lazy').setup({
  'nvim-lua/plenary.nvim',          -- Lua funcs used by plugins
  'nvim-lualine/lualine.nvim',      -- Customisable statusline
  'tpope/vim-sleuth',               -- Auto tabstop and shiftwidth
  'tpope/vim-fugitive',             -- Git integration
  'lewis6991/gitsigns.nvim',        -- Git decorations
  'tpope/vim-rhubarb',              -- Github integration
  'folke/which-key.nvim',           -- Shows available keybinds
  'hrsh7th/nvim-cmp',               -- Autocomplete engine
  'L3MON4D3/LuaSnip',               -- Snippet engine
  'saadparwaiz1/cmp_luasnip',       -- nvim-cmp source for LuaSnip
  'hrsh7th/cmp-nvim-lsp',           -- nvim-cmp source for LSP
  'hrsh7th/cmp-path',               -- nvim-cmp source for filepaths
  'rafamadriz/friendly-snippets',   -- Various language snippets
  'neovim/nvim-lspconfig',          -- Configures nvim's LSP client
  'mason-org/mason-lspconfig.nvim', -- mason x nvim-lspconfig bridge
  'folke/lazydev.nvim',             -- Adds nvim API support to Lua
  'numToStr/Comment.nvim',          -- Toggle comments
  'smithbm2316/centerpad.nvim',     -- Centerpad a buffer
  {
    'mason-org/mason.nvim',         -- Package manager for LSP servers
    lazy = true,
  },
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  { 'j-hui/fidget.nvim', opts = {} }, -- LSP status notification UI
  {
    'EdenEast/nightfox.nvim',         -- Nightfox colourscheme
    priority = 1000,
    lazy = true,
  },
  {
    'lukas-reineke/indent-blankline.nvim', -- Indentation guides
    main = 'ibl',
  },
  {
    'nvim-telescope/telescope.nvim', -- Fuzzy-finder, navigator
    branch = '0.1.x',
    lazy = true,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim', -- Telescope fzf support
    build = 'make',
    cond = function() return vim.fn.executable 'make' == 1 end,
  },
  'nvim-treesitter/nvim-treesitter-textobjects', -- Custom Treesitter objects
  {
    'nvim-treesitter/nvim-treesitter',           -- Highlight, edit, navigate code
    build = ':TSUpdate',
    lazy = true,
  },

}, {})
