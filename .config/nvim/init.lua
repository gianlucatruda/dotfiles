-- Gianluca's nvim config
-- Based on Kickstart.nvim circa 2024
-- Modularised 2025-05-08

require("core.options") -- Goes to lua/core/options.lua
require("core.keymaps") -- Goes to lua/core/keymaps.lua

-- This saves up to 400ms on startup when opening python files
vim.g.python3_host_prog = '~/.pyenv/shims/python3'

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("core.plugins")  -- Goes to lua/core/plugins.lua
require("plugin_config") -- Goes to lua/plugin_config/init.lua
