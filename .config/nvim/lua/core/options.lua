-- BASICS
vim.opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
vim.wo.number = true              -- Make line numbers default
-- vim.opt.relativenumber = true    -- Enable relative line numbers
vim.opt.cursorline = true         -- Highlight current line
vim.opt.wildmenu = true           -- Enhance command-line completion
vim.opt.scrolloff = 10            -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8         -- Keep 8 columns left/right of cursor
vim.opt.linebreak = true          -- word wrap
vim.opt.wrap = true               -- line wrap

-- Set good default colours and inherit (overridden if plugins load)
vim.opt.termguicolors = false -- 24-bit colors
vim.g.colors_name = "default"
vim.opt.background = "dark"   -- or light
vim.opt.syntax = "on"         -- Enable syntax highlighting

-- INDENTATION
vim.opt.autoindent = true  -- Align the new line indent with the previous line
vim.opt.breakindent = true -- Enable break indent
vim.opt.smartindent = true -- Smart auto-indenting
-- Gianluca's custom tab settings (vim-sleuth will override in some contexts?) -----
-- Note: these are similar to my defaults in .vimrc for vanilla vim (good baseline)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- SEARCHING
vim.opt.ignorecase = true -- Case-insensitive searching
vim.opt.smartcase = true  -- Case sensitive if uppercase in search
vim.opt.incsearch = true  -- Highlight dynamically as pattern is typed
vim.opt.hlsearch = true   -- Highlight searches

-- BEHAVIOUR
vim.opt.mouse = "a"                      -- Enable mouse in all modes
vim.opt.backspace = "indent,eol,start"   -- Allow backspace in insert mode
vim.opt.startofline = false              -- Don't reset cursor to start of line when moving around
vim.opt.shortmess:append("atI")          -- Don't show the intro message when starting Vim
vim.opt.errorbells = false               -- No annoyances on errors
vim.opt.visualbell = false               -- No annoyances on errors
vim.wo.signcolumn = 'yes'                -- Keep signcolumn on by default
vim.opt.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience

-- DISPLAY
vim.opt.title = true -- Show the titlestring in the window titlebar
vim.opt.titlelen = 25
-- according to h: titlestring uses same syntax as statusline with filename-modifiers
vim.opt.titlestring = '%{fnamemodify(getcwd(), ":t")}:%t'
vim.opt.showmode = false -- Show the current mode
vim.opt.showcmd = true  -- Show the (partial) command as it's being typed

-- PERFORMANCE
vim.opt.updatetime = 1000     -- Reduce idle time for CursorHold/checktime
vim.opt.timeoutlen = 300      -- Reduce key timeout duration
vim.opt.redrawtime = 10000    -- Increase max redraw time
vim.opt.maxmempattern = 20000 -- Increase max syntax highlight memory

-- FILES
vim.opt.undofile = true -- Save undo history
vim.opt.autoread = true -- Auto read when a file is changed externally
-- Check if file is modified and prompt to reload
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "checktime"
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.bo.formatprg = 'prettier --stdin-filepath %'
  end,
})

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
