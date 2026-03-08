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

local function tmux_environment(name)
  local line = vim.fn.systemlist({ 'tmux', 'show-environment', name })[1]

  if vim.v.shell_error ~= 0 or not line or vim.startswith(line, '-') then
    return nil
  end

  return line:match('^[^=]+=([%s%S]*)$')
end

local function use_ghostty_tokyonight()
  if vim.env.DOTFILES_TERM == 'ghostty'
    or vim.env.GHOSTTY_RESOURCES_DIR
    or vim.env.TERM_PROGRAM == 'ghostty' then
    return true
  end

  if not vim.env.TMUX then
    return false
  end

  return tmux_environment('DOTFILES_TERM') == 'ghostty'
end

vim.g.dotfiles_use_ghostty_tokyonight = use_ghostty_tokyonight()

-- Match Ghostty's theme, otherwise fall back to terminal-owned colors.
vim.opt.termguicolors = vim.g.dotfiles_use_ghostty_tokyonight -- 24-bit colors
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
vim.opt.showmode = false -- Hide mode; lualine already shows it
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

-- Use Prettier for Markdown formatting; marksman does not format.
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
