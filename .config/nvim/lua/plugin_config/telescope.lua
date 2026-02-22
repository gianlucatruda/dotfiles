local actions = require('telescope.actions')
local actions_layout = require('telescope.actions.layout')
local path = require('core.path')

local function display_path(_, entry_path)
  local display = vim.fn.fnamemodify(entry_path, ':~:.')
  local max_width = vim.api.nvim_win_get_width(0) - 8
  if max_width <= 0 then
    max_width = vim.o.columns
  end
  return path.shorten_middle(display, max_width)
end

require('telescope').setup {
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.96,
      height = 0.9,
      preview_width = 0.25,
      preview_cutoff = 140,
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    -- Keep head + tail visible; built-ins can't preserve both ends.
    path_display = display_path,
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<M-p>'] = { actions_layout.toggle_preview, desc = 'Toggle preview' },
        ['?'] = { actions.which_key, desc = 'Show keymaps' },
      },
      n = {
        ['<M-p>'] = { actions_layout.toggle_preview, desc = 'Toggle preview' },
        ['?'] = { actions.which_key, desc = 'Show keymaps' },
      },
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')

local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local start_dir = current_file ~= '' and vim.fs.dirname(current_file) or vim.fn.getcwd()
  return vim.fs.root(start_dir, { '.git' }) or vim.fn.getcwd()
end

local function live_grep_git_root()
  require('telescope.builtin').live_grep {
    search_dirs = { find_git_root() },
    additional_args = function()
      return { '--hidden', '--glob', '!.git/' }
    end,
  }
end

local function live_grep_git_root_all()
  require('telescope.builtin').live_grep {
    search_dirs = { find_git_root() },
    additional_args = function()
      return { '--hidden', '--no-ignore', '--glob', '!.git/' }
    end,
  }
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
vim.api.nvim_create_user_command('LiveGrepGitRootAll', live_grep_git_root_all, {})

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').git_files { cwd = find_git_root(), show_untracked = true, recurse_submodules = false }
end, { desc = '[S]earch [F]iles (tracked + untracked, git root)' })
vim.keymap.set('n', '<leader>sF', function()
  require('telescope.builtin').find_files {
    cwd = find_git_root(),
    hidden = true,
    no_ignore = true,
    file_ignore_patterns = { '.git/' },
  }
end, { desc = '[S]earch [F]iles (all, git root, except .git/)' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep (tracked, git root)' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRootAll<cr>', { desc = '[S]earch by [G]rep (all, git root, except .git/)' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
