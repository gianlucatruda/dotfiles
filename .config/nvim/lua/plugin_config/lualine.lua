local path = require('core.path')

local function winbar_path()
  local bufnr = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return '[No Name]'
  end

  -- Prefer git-root-relative paths so the winbar stays stable across splits.
  local root = vim.fs.root(vim.fs.dirname(name), { '.git' }) or vim.fn.getcwd()
  local rel = vim.fs.relpath(root, name) or vim.fn.fnamemodify(name, ':.')
  local max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.9)
  return path.shorten_middle(rel, max_width)
end

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  winbar = {
    lualine_c = { winbar_path },
  },
  inactive_winbar = {
    lualine_c = { winbar_path },
  },
}
