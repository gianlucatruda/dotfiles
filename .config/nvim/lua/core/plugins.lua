require('lazy').setup({
  'tpope/vim-fugitive',    -- Git related plugin
  'tpope/vim-rhubarb',     -- Git related plugins
  'tpope/vim-sleuth',      -- Detect tabstop and shiftwidth automatically
  'folke/which-key.nvim',  -- Useful plugin to show you pending keybinds.
  'neovim/nvim-lspconfig', -- LSP support
  { 'williamboman/mason.nvim', config = true },
  'williamboman/mason-lspconfig.nvim',
  -- Useful status updates for LSP
  'j-hui/fidget.nvim',
  -- Additional lua configuration, makes nvim stuff amazing!
  'folke/neodev.nvim',
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  -- Snippets
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  -- Adds LSP completion capabilities
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  -- Adds a number of user-friendly snippets
  'rafamadriz/friendly-snippets',
  'lewis6991/gitsigns.nvim',
  -- Nightfox colourscheme
  { 'EdenEast/nightfox.nvim',  priority = 1000, lazy = false, },
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- Add indentation guides even on blank lines
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', },
  -- Use "gc" to toggle comment on visual regions/lines
  'numToStr/Comment.nvim',
  -- Fuzzy Finder (files, lsp, etc)
  'nvim-lua/plenary.nvim',
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function() return vim.fn.executable 'make' == 1 end,
  },
  { 'nvim-telescope/telescope.nvim',       branch = '0.1.x', },
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter-textobjects',
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', },
  -- Centerpad a single buffer
  'smithbm2316/centerpad.nvim',
}, {})
