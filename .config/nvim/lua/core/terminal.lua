local M = {}

local dotfiles_term

-- Read tmux's managed environment so nested shells and Neovim agree on the terminal marker.
local function tmux_environment(name)
  local line = vim.fn.systemlist({ 'tmux', 'show-environment', name })[1]

  if vim.v.shell_error ~= 0 or not line or vim.startswith(line, '-') then
    return nil
  end

  return line:match('^[^=]+=([%s%S]*)$')
end

function M.environment(name)
  if vim.env.TMUX then
    return tmux_environment(name)
  end

  return vim.env[name]
end

function M.dotfiles_term()
  if dotfiles_term == nil then
    dotfiles_term = M.environment('DOTFILES_TERM') or ''
  end

  return dotfiles_term
end

function M.is_ghostty()
  return M.dotfiles_term() == 'ghostty'
end

return M
