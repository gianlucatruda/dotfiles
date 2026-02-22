-- See `:help telescope` and `:help telescope.setup()`
local actions = require('telescope.actions')
local actions_layout = require('telescope.actions.layout')

local function compact_path(_, path)
  local display = vim.fn.fnamemodify(path, ':~:.')
  local max_width = vim.api.nvim_win_get_width(0) - 8
  if max_width <= 0 then
    max_width = vim.o.columns
  end

  if vim.fn.strdisplaywidth(display) <= max_width then
    return display
  end

  local sep = package.config:sub(1, 1)
  local parts = vim.split(display, sep, { plain = true, trimempty = true })
  if #parts <= 4 then
    return display
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
require('telescope').setup {
  defaults = {
    -- Layout: keep the list wide with a compact preview.
    -- Swap to 'vertical' or 'flex' if you prefer a taller layout.
    layout_strategy = 'horizontal',
    layout_config = {
      -- width/height accept floats (0-1) or absolute columns/rows.
      width = 0.96,
      height = 0.9,
      -- Keep preview small and drop it on narrow screens.
      preview_width = 0.25,
      preview_cutoff = 140,
      -- prompt_position can be 'top' or 'bottom'.
      prompt_position = 'top',
    },
    -- 'ascending' keeps the prompt at the top; 'descending' flips it.
    sorting_strategy = 'ascending',
    -- path_display options include 'shorten', 'smart', 'absolute', and 'tail'.
    path_display = compact_path,
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        -- Remap if your terminal uses Alt for other shortcuts.
        ['<M-p>'] = { actions_layout.toggle_preview, desc = 'Toggle preview' },
        ['?'] = { actions.which_key, desc = 'Show keymaps' },
      },
      n = {
        -- Remap if your terminal uses Alt for other shortcuts.
        ['<M-p>'] = { actions_layout.toggle_preview, desc = 'Toggle preview' },
        ['?'] = { actions.which_key, desc = 'Show keymaps' },
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search tracked files in git root (including hidden, excluding .git/)
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
      -- Drop --hidden if you want to respect default ripgrep ignores.
      additional_args = function() return { "--hidden", "--glob", "!.git/" } end
    }
  end
end

-- Custom live_grep function to search ALL files in git root (including hidden, except .git/)
local function live_grep_git_root_all()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
      -- Drop --no-ignore if you want to respect .gitignore.
      additional_args = function() return { "--hidden", "--no-ignore", "--glob", "!.git/" } end
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
vim.api.nvim_create_user_command('LiveGrepGitRootAll', live_grep_git_root_all, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
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
vim.keymap.set('n', '<leader>sf',
  function()
    local git_root = find_git_root()
    if git_root then
      require('telescope.builtin').git_files({ cwd = git_root, show_untracked = true, recurse_submodules = false })
    end
  end,
  { desc = '[S]earch [F]iles (tracked + untracked, git root)' })
vim.keymap.set('n', '<leader>sF',
  function()
    local git_root = find_git_root()
    if git_root then
      require('telescope.builtin').find_files({ cwd = git_root, hidden = true, no_ignore = true, file_ignore_patterns = { ".git/" } })
    end
  end,
  { desc = '[S]earch [F]iles (all, git root, except .git/)' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep (tracked, git root)' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRootAll<cr>', { desc = '[S]earch by [G]rep (all, git root, except .git/)' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
