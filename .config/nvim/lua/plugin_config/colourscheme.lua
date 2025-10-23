local function detect_alacritty()
  -- Figure out if running in alacritty (to apply same colourscheme)
  if vim.env.ALACRITTY_LOG or vim.env.ALACRITTY_SOCKET then
    return true
  end
  return false
end

local running_in_alacritty = detect_alacritty()

if running_in_alacritty then
  require('nightfox').setup({
    options = {
      compile_path = vim.fn.stdpath("cache") .. "/nightfox", -- Compilation
      compil_file_suffix = "_compiled",                      -- Cache compiled themes
      module_default = false,                                -- Disable unused themes
    },
  })

  vim.cmd("colorscheme nightfox")
  require('nightfox').load()
end
