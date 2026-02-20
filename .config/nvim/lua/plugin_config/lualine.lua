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
        -- path: 0 = filename, 1 = relative, 2 = absolute.
        path = 1,
        -- shorting_target: 0 disables shortening (full path in winbar).
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
    -- Enable icons if you add a devicons plugin.
    icons_enabled = false,
    -- Swap to a named theme if you want to force one.
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
        -- path: 0 = filename, 1 = relative, 2 = absolute.
        path = 1,
        -- shorting_target: increase for more path context.
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
