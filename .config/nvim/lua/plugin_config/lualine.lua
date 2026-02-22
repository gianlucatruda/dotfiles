-- Toggle these if you want a quieter UI or no winbar at all.
local show_diagnostics = true
local show_winbar = true
-- Diagnostics summary shows counts only; swap symbols/source to taste.
-- Use `nvim_lsp` if you only want LSP diagnostics.
local diagnostics_summary = {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' },
}

local mode_labels = {
  NORMAL = 'N',
  INSERT = 'I',
  VISUAL = 'V',
  ['V-LINE'] = 'VL',
  ['V-BLOCK'] = 'VB',
  REPLACE = 'R',
  COMMAND = 'C',
  TERMINAL = 'T',
  SELECT = 'S',
  ['S-LINE'] = 'SL',
  ['S-BLOCK'] = 'SB',
}

local function mode_format(mode)
  if mode == nil or mode == '' then
    return ''
  end

  return mode_labels[mode] or mode:sub(1, 1)
end

local function compact_branch(branch)
  if branch == nil or branch == '' then
    return ''
  end

  local width = vim.api.nvim_win_get_width(0)
  local max_len = math.floor(width * 0.4)
  if #branch <= max_len then
    return branch
  end

  return branch:sub(1, math.max(max_len - 1, 1)) .. '…'
end

local function git_root_for_buf(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    return nil
  end

  local dir = vim.fs.dirname(path)
  return vim.fs.root(dir, { '.git' })
end

local function shorten_path(path, max_width)
  if vim.fn.strdisplaywidth(path) <= max_width then
    return path
  end

  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, sep, { plain = true, trimempty = true })
  if #parts <= 4 then
    return path
  end

  local function build(head, tail)
    local result = {}
    for i = 1, head do
      table.insert(result, parts[i])
    end
    table.insert(result, '...')
    for i = #parts - tail + 1, #parts do
      table.insert(result, parts[i])
    end
    return table.concat(result, sep)
  end

  local candidate = build(2, 2)
  if vim.fn.strdisplaywidth(candidate) <= max_width then
    return candidate
  end

  candidate = build(1, 2)
  if vim.fn.strdisplaywidth(candidate) <= max_width then
    return candidate
  end

  candidate = build(1, 1)
  if vim.fn.strdisplaywidth(candidate) <= max_width then
    return candidate
  end

  return '...' .. sep .. parts[#parts]
end

local function winbar_path()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    return '[No Name]'
  end

  local root = git_root_for_buf(bufnr) or vim.fn.getcwd()
  local rel = vim.fs.relpath(root, path) or vim.fn.fnamemodify(path, ':.')
  local width = math.floor(vim.api.nvim_win_get_width(0) * 0.9)
  return shorten_path(rel, width)
end

local lualine_b = { { 'branch', fmt = compact_branch } }
if show_diagnostics then
  table.insert(lualine_b, diagnostics_summary)
end

local winbar = nil
if show_winbar then
  winbar = {
    lualine_c = {
      {
        winbar_path,
      },
    },
  }
end

require('lualine').setup {
  options = {
    -- Enable icons if you add a devicons plugin.
    icons_enabled = false,
    -- Swap to a named theme if you want to force one.
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = { { 'mode', fmt = mode_format } },
    lualine_b = lualine_b,
    lualine_c = {
      {
        'filename',
        path = 0,
        symbols = {
          modified = '[+]',
          readonly = '[RO]',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
      },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  winbar = winbar,
  inactive_winbar = winbar,
}
