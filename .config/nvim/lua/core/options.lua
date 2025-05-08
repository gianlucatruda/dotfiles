-- Mirror basic settings of .vimrc here ---------------------------------------

-- Set good default colours and inherit (overridden if plugins load)
vim.opt.termguicolors = false
vim.g.colors_name = "default"
vim.opt.background = "dark" -- or light

-- Enable syntax highlighting
vim.opt.syntax = "on"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Align the new line indent with the previous line
vim.opt.autoindent = true

-- Set to auto read when a file is changed from the outside
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime"
})

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enhance command-line completion
vim.opt.wildmenu = true

-- Allow backspace in insert mode
vim.opt.backspace = "indent,eol,start"

-- Make line numbers default
vim.wo.number = true

-- Enable relative line numbers
-- vim.opt.relativenumber = true

-- Highlight searches
vim.opt.hlsearch = true

-- Highlight dynamically as pattern is typed
vim.opt.incsearch = true

-- Enable mouse in all modes
vim.opt.mouse = "a"

-- Don't reset cursor to start of line when moving around
vim.opt.startofline = false

-- Don't show the intro message when starting Vim
vim.opt.shortmess:append("atI")

-- Show the current mode
vim.opt.showmode = true

-- Show the filename in the window titlebar
vim.opt.title = true

-- Show the (partial) command as it's being typed
vim.opt.showcmd = true

-- Start scrolling three lines before the horizontal window border
vim.opt.scrolloff = 3

-- Word and Line wrapping
vim.opt.linebreak = true -- word wrap
vim.opt.wrap = true      -- Wrap lines

-- No annoying sound on errors
vim.opt.errorbells = false
vim.opt.visualbell = false

-------------------------------------------------------------------------------

-- Gianluca's custom tab settings (vim-sleuth will override in some contexts?) -----
-- Note: these are similar to my defaults in .vimrc for vanilla vim (good baseline)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
print("Debug: Options loaded")
