local show_diagnostics = true
local show_winbar = true
local diagnostics_summary = {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' },
}

local lualine_b = { 'branch', 'diff' }
if show_diagnostics then
  table.insert(lualine_b, diagnostics_summary)
end

local winbar = nil
if show_winbar then
  winbar = {
    lualine_c = {
      {
        -- Winbar keeps full path context while the statusline stays compact.
        'filename',
        path = 1,
        shorting_target = 0,
        symbols = {
          modified = '[+]',
          readonly = '[RO]',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
      },
    },
  }
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
    lualine_b = lualine_b,
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 40,
        symbols = {
          modified = '[+]',
          readonly = '[RO]',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  winbar = winbar,
  inactive_winbar = winbar,
}
