-- Basics
vim.opt.clipboard = 'unnamedplus'
vim.wo.number = true
vim.opt.cursorline = true
vim.opt.wildmenu = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.linebreak = true
vim.opt.wrap = true

local function tmux_environment(name)
  local line = vim.fn.systemlist({ 'tmux', 'show-environment', name })[1]

  if vim.v.shell_error ~= 0 or not line or vim.startswith(line, '-') then
    return nil
  end

  return line:match('^[^=]+=([%s%S]*)$')
end

local function is_ghostty()
  if vim.env.TMUX then
    return tmux_environment('DOTFILES_TERM') == 'ghostty'
  end

  return vim.env.DOTFILES_TERM == 'ghostty'
end

vim.g.dotfiles_is_ghostty = is_ghostty()

-- Let Ghostty opt into Neovim-owned colors; other terminals keep their own palette.
vim.opt.termguicolors = vim.g.dotfiles_is_ghostty
vim.opt.background = 'dark'
vim.opt.syntax = 'on'

-- Indentation
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Behavior
vim.opt.mouse = 'a'
vim.opt.backspace = 'indent,eol,start'
vim.opt.startofline = false
vim.opt.shortmess:append('atI')
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.wo.signcolumn = 'yes'
vim.opt.completeopt = 'menuone,noselect'

-- Display
vim.opt.title = true
vim.opt.titlelen = 25
vim.opt.titlestring = '%{fnamemodify(getcwd(), ":t")}:%t'
vim.opt.showmode = false
vim.opt.showcmd = true

-- Performance
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 300
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- Files
vim.opt.undofile = true
vim.opt.autoread = true

-- Reload buffers when files change on disk.
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  command = 'checktime',
})

-- Use Prettier for Markdown formatting; marksman does not format.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.bo.formatprg = 'prettier --stdin-filepath %'
  end,
})

-- Highlight yanked text briefly.
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
