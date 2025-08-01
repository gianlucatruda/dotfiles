require('nightfox').setup({
  options = {
    compile_path = vim.fn.stdpath("cache") .. "/nightfox", -- Compilation
    compil_file_suffix = "_compiled",                      -- Cache compiled themes
    module_default = false,                                -- Disable unused themes
  },
})

vim.cmd("colorscheme nightfox")
require('nightfox').load()
