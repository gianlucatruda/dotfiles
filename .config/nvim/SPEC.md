# Neovim Configuration SPEC

This document exhaustively describes the Neovim configuration in this dotfiles repo. It is written so the setup can be recreated from scratch without reading the original files. All behavior described here is based on the actual configuration and its surrounding dotfiles context.

## Scope

- Focus: Neovim functionality and capabilities enabled by the config under `~/.config/nvim`.
- Context: supporting shell, terminal, and tooling settings in the dotfiles that affect Neovim.
- Non-goals: general shell or tmux behavior unless it directly affects Neovim.

## File Layout and Load Order

Directory layout (relative to `~/.config/nvim`):

```
init.lua
lazy-lock.json
lua/
  core/
    keymaps.lua
    options.lua
    path.lua
    plugins.lua
  plugin_config/
    blink.lua
    colourscheme.lua
    gitsigns.lua
    ibl.lua
    init.lua
    lazydev.lua
    lazygit.lua
    lsp.lua
    lualine.lua
    oil.lua
    telescope.lua
    treesitter.lua
```

Startup flow (exact order):

1. `init.lua` loads core options and keymaps.
2. Sets the Python host program to `~/.pyenv/shims/python3`.
3. Installs and prepends `lazy.nvim` if not present.
4. Loads plugin definitions from `lua/core/plugins.lua`.
5. Unless `NVIM_DOTFILES_CHECKHEALTH=1` is set, loads plugin configs from `lua/plugin_config/init.lua` in a fixed order.

Plugin config load order (in `lua/plugin_config/init.lua`):

1. `colourscheme`
2. `lualine`
3. `gitsigns`
4. `lazygit`
5. `telescope`
6. `oil`
7. `treesitter`
8. `blink`
9. `lazydev`
10. `lsp`
11. `ibl`

Health check mode:

- If you set `NVIM_DOTFILES_CHECKHEALTH=1`, the plugin configs are skipped. This is used to avoid errors during isolated headless health checks while plugins are still installing.

## Requirements and External Dependencies

Minimum versions and required binaries:

- Neovim 0.11+ (the config uses `vim.lsp.config` and `vim.lsp.enable` which are 0.11-era APIs).
- Git (used by `lazy.nvim`, `telescope git_files`, Fugitive, and Gitsigns).
- `make` (needed to build `telescope-fzf-native` if you want the FZF extension).
- `rg` (ripgrep) for `telescope` live grep.
- `lazygit` binary for the LazyGit integration.
- Node.js runtime (required for `ts_ls` and for the Mason-installed `prettier` binary).
- A working Python interpreter at `~/.pyenv/shims/python3`, or adjust `vim.g.python3_host_prog`.

Recommended (from the dotfiles context):

- Alacritty terminal. The colorscheme is only applied automatically when running in Alacritty.
- A Nerd Font (the dotfiles use UbuntuMono Nerd Font in Alacritty), though icons are disabled in lualine so this is not required for core functionality.

## Core Options (Editor Behavior)

The following settings are explicitly set in `lua/core/options.lua`:

Basics:

- System clipboard integration: `clipboard = unnamedplus`.
- Line numbers: absolute line numbers are enabled (`number = true`); relative numbers are off.
- Cursorline is highlighted.
- Command-line completion uses `wildmenu`.
- Scrolling: `scrolloff = 10`, `sidescrolloff = 8`.
- Line wrap enabled with word boundary wrapping: `wrap = true`, `linebreak = true`.

Color and syntax:

- `termguicolors = false` (true color is disabled by default).
- `background = dark` and `colors_name = default`.
- `syntax = on` (syntax highlighting is enabled).

Indentation:

- `autoindent`, `breakindent`, `smartindent` enabled.
- `tabstop = 4` and `shiftwidth = 4` as defaults. `vim-sleuth` can override these per-file.

Search:

- Case-insensitive by default (`ignorecase = true`) with smartcase.
- Incremental search and highlight are enabled.

Behavior:

- Mouse enabled in all modes (`mouse = a`).
- Backspace works in insert mode over indent/eol/start.
- `startofline = false` to keep column when moving.
- Intro message suppressed (`shortmess += atI`).
- Error bells disabled (`errorbells = false`, `visualbell = false`).
- Sign column always shown (`signcolumn = yes`).
- `completeopt = menuone,noselect` for completion UX.

Display:

- Window title enabled (`title = true`) with `titlestring = %{fnamemodify(getcwd(), ":t")}:%t` and `titlelen = 25`.
- `showmode = false` (mode display is handled by lualine).
- `showcmd = true`.

Performance:

- `updatetime = 1000` (affects CursorHold, checktime).
- `timeoutlen = 300` (affects which-key and leader sequences).
- `redrawtime = 10000`, `maxmempattern = 20000`.
- `vim.g.python3_host_prog` is set to `~/.pyenv/shims/python3` to reduce startup time for Python files (adjust if you use a different Python manager).

Files:

- Persistent undo enabled (`undofile = true`).
- Auto-read external changes (`autoread = true`).
- Auto-check for file changes on FocusGained, BufEnter, CursorHold, CursorHoldI via `checktime`.
- Markdown buffers set `formatprg = "prettier --stdin-filepath %"` (marksman does not format Markdown).
- Yank highlight enabled on `TextYankPost`.

## Core Keymaps (Non-plugin)

Leader:

- `<Space>` is leader and localleader. `<Space>` is mapped to `<Nop>` to avoid default behavior.

Editing and navigation:

- Visual mode: `J` moves selection down, `K` moves selection up, maintaining selection and reindent.
- `j` and `k` move by display line (gj/gk) when no count is given; counts keep normal movement.

Utilities:

- `<leader>id` inserts current date (yyyy-mm-dd) via the shell `date` command.
- `<leader><Tab>` jumps to the previous buffer (`:b#`).

Diagnostics (built-in):

- `<leader>e` opens a floating diagnostic message.
- `<leader>q` opens the diagnostics location list.

## Plugin Manager and Plugins

Plugin manager:

- `lazy.nvim` is bootstrapped in `init.lua` if missing.
- Bootstrap details: clones `https://github.com/folke/lazy.nvim.git` (stable branch) to `stdpath('data') .. '/lazy/lazy.nvim'` using `git clone --filter=blob:none`, then prepends that path to `runtimepath`.
- Plugins are defined in `lua/core/plugins.lua`.
- `lazy-lock.json` pins exact plugin commits for reproducibility.

Active plugins (configured or used):

- `nvim-lua/plenary.nvim` (dependency for other plugins).
- `nvim-lualine/lualine.nvim` (statusline + winbar).
- `tpope/vim-sleuth` (auto-detect indent style).
- `tpope/vim-fugitive` (Git commands inside Neovim).
- `lewis6991/gitsigns.nvim` (inline Git hunk signs and actions).
- `tpope/vim-rhubarb` (GitHub integration for Fugitive).
- `kdheepak/lazygit.nvim` (LazyGit integration).
- `folke/which-key.nvim` (keybinding hint popup).
- `stevearc/oil.nvim` (file explorer, optional).
- `L3MON4D3/LuaSnip` + `rafamadriz/friendly-snippets` (snippets).
- `saghen/blink.cmp` (completion UI).
- `neovim/nvim-lspconfig` (LSP client configs).
- `mason-org/mason.nvim` (LSP/tool installer).
- `mason-org/mason-lspconfig.nvim` (Mason bridge for LSP).
- `WhoIsSethDaniel/mason-tool-installer.nvim` (ensures extra tools).
- `folke/lazydev.nvim` (Lua dev enhancements).
- `numToStr/Comment.nvim` (installed but not configured; see "Inactive" section).
- `j-hui/fidget.nvim` (LSP status notifications).
- `EdenEast/nightfox.nvim` (colorscheme; conditional).
- `lukas-reineke/indent-blankline.nvim` (indent guides via `ibl`).
- `nvim-telescope/telescope.nvim` + `telescope-fzf-native.nvim` (fuzzy finder).
- `nvim-treesitter/nvim-treesitter` + `nvim-treesitter-textobjects` (syntax + text objects).

Plugin definitions with non-default options:

- `saghen/blink.cmp`: `version = "1.*"`, depends on `friendly-snippets`.
- `mason-org/mason.nvim`: `lazy = true` (loaded on demand by `require('mason')`).
- `EdenEast/nightfox.nvim`: `priority = 1000`, `lazy = true`.
- `lukas-reineke/indent-blankline.nvim`: `main = "ibl"`.
- `nvim-telescope/telescope.nvim`: `branch = "0.1.x"`, `lazy = true`.
- `nvim-telescope/telescope-fzf-native.nvim`: `build = "make"`, `cond = executable('make') == 1`.
- `nvim-treesitter/nvim-treesitter`: `build = ":TSUpdate"`, `lazy = true`.
- `j-hui/fidget.nvim`: `opts = {}` (defaults).

## UI and Appearance

Colorscheme:

- `nightfox` is only applied if Neovim is running inside Alacritty (detected by `ALACRITTY_LOG` or `ALACRITTY_SOCKET`).
- Nightfox setup options:
  - `compile_path = stdpath("cache") .. "/nightfox"`
  - `compil_file_suffix = "_compiled"` (note the spelling)
  - `module_default = false`
- After setup: `colorscheme nightfox` then `require('nightfox').load()`.
- Otherwise, the default Vim colors are used (`colors_name = default`), with `termguicolors = false`.

Statusline and winbar (lualine):

- Icons disabled.
- Theme set to `auto`.
- Component separators: `|`, section separators: empty.
- Sections: `mode`, `branch`, `diff`, `diagnostics`, `filename`, `location`.
- `lualine_x` and `lualine_y` are empty.
- Winbar shows the current file path, relative to the Git root when available, otherwise relative to CWD.
- Relative path uses `vim.fs.relpath(root, name)` with fallback to `vim.fn.fnamemodify(name, ':.')`.
- Unnamed buffers show `[No Name]` in the winbar.
- The same winbar is used for inactive windows.
- Winbar width target is ~90% of the current window width; paths are shortened with a custom middle-elision algorithm (see `core/path.lua`).

Indent guides:

- `indent-blankline` (`ibl`) enabled with default settings.

LSP UI status:

- `fidget.nvim` is enabled with defaults for LSP status notifications.

## Path Shortening Logic (core/path.lua)

This helper is used by the winbar and Telescope to keep paths readable:

- If `path` is empty or within `max_width`, return as-is.
- Split by the OS path separator.
- If the path has 4 or fewer segments, return as-is.
- Otherwise, try these candidates in order and return the first that fits:
  - First 2 segments + `...` + last 2 segments
  - First 1 segment + `...` + last 2 segments
  - First 1 segment + `...` + last 1 segment
- If none fit, return `.../<basename>`.

## Completion and Snippets

Completion engine: `blink.cmp` with LuaSnip for snippets.

Behavior:

- `preset = "enter"` for base keymaps.
- Overrides:
  - `<Tab>`: select next item or jump forward in snippet.
  - `<S-Tab>`: select previous item or jump backward in snippet.
  - `<C-n>`: insert next item.
  - `<C-p>`: insert previous item.
- Auto-show completion menu is controlled by `vim.g.blink_auto_trigger` (default true).
- If `vim.g.blink_auto_trigger` is nil, it is initialized to `true` on startup.
- Menu columns: `kind_icon`, then `label` + `label_description` with a 1-char gap.
- Documentation popup auto-shows after 150ms.
- Signature help popup is enabled.
- Snippets are wired via `snippets = { preset = 'luasnip' }`.

Sources and priority:

- Sources: LSP, path, snippets, buffer.
- Score offsets: LSP +15, path -5, snippets -8, buffer -12 (keeps LSP results dominant).
- LSP provider fallbacks are disabled (`fallbacks = {}`) to reduce noisy non-LSP matches.

Snippets:

- VS Code style snippets are lazily loaded from `friendly-snippets`.
- LuaSnip is initialized with default config via `luasnip.config.setup {}`.

Toggle:

- `<leader>tc` toggles the auto-triggered completion menu on/off and shows a notification.

## LSP and Diagnostics

General LSP behavior:

- LSP capabilities are extended using `blink.cmp` capabilities and applied globally via `vim.lsp.config('*', { capabilities = capabilities })`.
- If `stdpath('data') .. '/mason/bin'` exists, it is prepended to PATH inside Neovim to prefer Mason-managed tools (this only affects Neovim's environment).
- `mason-lspconfig` ensures servers are installed with `automatic_enable = false`; servers are enabled explicitly with `vim.lsp.enable(servers)`.
- Diagnostics and inlay hints can be toggled via leader keymaps.
- LSP UI state is tracked at startup:
  - `state.virtual_text` is based on `vim.diagnostic.config().virtual_text ~= false`.
  - `state.inlay_hints` uses `vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })` when supported.
  - `state.ty_diagnostic_mode` starts at `openFilesOnly`.

Configured LSP servers (installed via Mason and enabled):

- `clangd`
- `rust_analyzer`
- `ts_ls` (TypeScript/JavaScript)
- `html`
- `jsonls`
- `marksman` (Markdown)
- `lua_ls`
- `ruff` (Python lint/format only)
- `ty` (Python language server)

Mason tool installer:

- Ensures `stylua` and `prettier` are installed in Mason.
- `prettier` is used for Markdown formatting (via `formatprg`).
- `stylua` is installed but not directly wired into formatting in this config.

LSP server specifics:

- `lua_ls`:
  - `checkThirdParty = false`
  - Telemetry disabled
  - Diagnostics disable `missing-fields`

- Python root markers (used by both `ruff` and `ty`):
  - `pyproject.toml`, `setup.cfg`, `setup.py`, `requirements.txt`, `Pipfile`, `uv.lock`,
    `ruff.toml`, `.ruff.toml`, `ty.toml`, `.venv`, `.git`

- `ruff`:
  - `cmd = { "ruff", "server" }`
  - `filetypes = { "python" }`
  - `single_file_support = true`
  - `root_markers` use the Python root marker list above
  - Lint and format enabled; syntax errors suppressed (`showSyntaxErrors = false`)
  - Language features (hover, goto, rename, completion, etc.) are explicitly disabled so Ty owns them

- `ty`:
  - `cmd = { "ty", "server" }`
  - `filetypes = { "python" }`
  - `single_file_support = true`
  - `root_markers` use the Python root marker list above
  - Diagnostics mode is tracked and toggled (default: `openFilesOnly`)
  - Auto-import completions enabled
  - Inlay hints for variable types and call argument names enabled

Encoding fix for Ty:

- `vim.lsp.util.make_position_params` is wrapped once to ensure position encoding defaults to the active client encoding.
- Encoding preference: use the `ty` client offset encoding if attached; otherwise use the first active LSP client.
- This avoids encoding mismatches (Ty uses UTF-16 offsets).

LSP keymaps (buffer-local on LSP attach):

- `<leader>rn` rename symbol
- `<leader>ca` code actions (filtered to `quickfix`, `refactor`, `source` kinds)
- `gd` go to definition
- `gr` references (Telescope; `show_line = false`, `trim_text = true`)
- `gI` implementations (Telescope)
- `<leader>D` type definitions (Telescope)
- `<leader>ds` document symbols (Telescope)
- `<leader>ws` workspace symbols (Telescope)
- `K` hover documentation
- `<C-k>` signature help
- `gD` go to declaration
- `<leader>wa` add workspace folder
- `<leader>wr` remove workspace folder
- `<leader>wl` list workspace folders
- `<leader>f` format current buffer
- `:Format` user command (buffer-local)

Formatting behavior:

- For Markdown buffers, formatting uses `formatprg` (`prettier --stdin-filepath %`) and runs `silent! keepjumps normal! gggqG` via `:Format` or `<leader>f`.
- For other filetypes, formatting uses `vim.lsp.buf.format`.

Diagnostics and UI toggles:

- `<leader>tld` toggle diagnostics on/off
- `<leader>tlv` toggle virtual text on/off
- `<leader>tli` toggle inlay hints on/off (warns if inlay hints are unsupported)
- `<leader>tlw` toggle Ty diagnostics between `openFilesOnly` and `workspace` (warns if Ty is not attached)
- `<leader>tla` toggle all LSP UI (diagnostics, virtual text, inlay hints, Ty workspace diagnostics)

Notes:

- Inlay hints are only enabled if the Neovim version supports them. A warning is shown otherwise.
- On each LSP attach, the current inlay hint state is applied to that buffer.
- Virtual text toggling restores the initial `vim.diagnostic.config()` virtual_text settings when re-enabled.
- `<leader>tla` enables Ty diagnostics in `workspace` mode and sets them back to `openFilesOnly` when disabling all LSP UI.
- Toggle actions use `vim.notify` to show state and include the related command string in the message.
- `toggle_inlay_hints`/`set_inlay_hints` applies across all loaded buffers with attached LSP clients.
- On LSP attach, if the client is `ty`, its diagnostics mode is reapplied via `workspace/didChangeConfiguration`.
- `which-key` group labels are registered for leader submenus (code, document, git, rename, search, workspace, toggle).

## Lua Development (lazydev)

- `lazydev.nvim` enhances Lua development by providing Neovim API typings.
- It loads the luv (libuv) type library when the word pattern `vim%.uv` is detected.
- Configured library entry: `{ path = '${3rd}/luv/library', words = { 'vim%.uv' } }`.

## Treesitter

Behavior:

- Treesitter setup is deferred with `vim.defer_fn` to improve startup time.
- `auto_install = true` for missing parsers.
- `sync_install = false`, `ignore_install = {}`, and `modules = {}` (defaults kept explicit).
- Highlight and indent modules are enabled.

Installed languages:

- c, cpp, go, lua, python, rust, tsx, javascript, typescript, vimdoc, vim, bash, html, latex, yaml, toml, markdown, svelte
- Note: the config list includes `bash` and `latex` twice; duplicates are harmless.

Incremental selection:

- `<leader>v` (normal) start selection
- `<leader>v` (visual) expand selection
- `<leader>V` (visual) shrink selection
- `<C-s>` scope increment (note: may require disabling terminal flow control)
- After setup, the `<leader>v` and `<leader>V` keymaps are redefined via `vim.keymap.set` so which-key shows labels.

Text objects:

- `aa` / `ia` parameter outer/inner
- `af` / `if` function outer/inner
- `ac` / `ic` class outer/inner
- Textobject select uses `lookahead = true` to jump forward to the next matching object.

Movement:

- `]m` / `[m` next/prev function start
- `]M` / `[M` next/prev function end
- `]]` / `[[` next/prev class start
- `][` / `[]` next/prev class end
- Textobject move sets `set_jumps = true` to populate the jumplist.

Swaps:

- `<leader>a` swap next parameter
- `<leader>A` swap previous parameter

## Search and Navigation (Telescope)

Default layout:

- Strategy: horizontal
- Width: 0.96, height: 0.9
- Preview width: 0.25, cutoff: 140
- Prompt at top, ascending sort
- Path display uses `fnamemodify(entry_path, ':~:.')` then the custom middle-shortening logic; max width is window width minus 8 (fallback to `vim.o.columns`).

Git root detection:

- Uses the current buffer path if available, otherwise the current working directory, then walks up for `.git` (fallback to CWD).

Telescope keymaps:

- `<leader>?` recently opened files
- `<leader><Space>` open buffers
- `<leader>/` fuzzy search in current buffer (dropdown, `winblend = 10`, no preview)
- `<leader>s/` live grep in open files (`prompt_title = "Live Grep in Open Files"`)
- `<leader>ss` Telescope builtins picker
- `<leader>gf` git files (requires a Git repo)
- `<leader>sf` git files from repo root, include untracked (`show_untracked = true`, `recurse_submodules = false`)
- `<leader>sF` find files from repo root, include hidden and ignored (except `.git/`) (`hidden = true`, `no_ignore = true`, `file_ignore_patterns = { '.git/' }`).
- `<leader>sh` help tags
- `<leader>sw` grep for word under cursor
- `<leader>sg` live grep from repo root, includes hidden, respects `.gitignore` (`--hidden --glob !.git/`)
- `<leader>sG` live grep from repo root, includes hidden and ignored (except `.git/`) (`--hidden --no-ignore --glob !.git/`)
- `<leader>sd` diagnostics
- `<leader>sr` resume last Telescope picker

Custom commands:

- `:LiveGrepGitRoot` (searches the git root, hidden files included, respects `.gitignore`, excludes `.git/`).
- `:LiveGrepGitRootAll` (searches the git root, includes ignored files, excludes `.git/`).

Telescope in-picker mappings:

- `Alt-p` toggles preview
- `?` shows Telescope keymaps
- `<C-u>` and `<C-d>` are disabled in insert mode
- `Alt-p` and `?` are available in both insert and normal modes inside Telescope.

Optional FZF extension:

- `telescope-fzf-native` is loaded if built (requires `make`).

## File Explorer (Oil + netrw)

- `oil.nvim` is installed but does not replace netrw (`default_file_explorer = false`).
- Keymaps:
  - `<leader>o` open Oil
  - `-` open parent directory in Oil (matches netrw muscle memory)

## Git Integration

Fugitive and Rhubarb:

- `vim-fugitive` is enabled with default commands (e.g. `:Git`, `:G`, `:Gdiffsplit`).
- `vim-rhubarb` adds GitHub support to Fugitive (e.g. `:GBrowse`).

Gitsigns:

- Signs in the sign column:
  - add: `+`
  - change: `~`
  - delete: `_`
  - topdelete: overline character (Unicode U+203E)
  - changedelete: `~`
- Gitsigns keymaps are buffer-local and only active when Gitsigns attaches.

Gitsigns keymaps:

- `]c` / `[c`: next/previous hunk (works in normal and visual modes; passes through to diff mode if `vim.wo.diff` is set)
- `<leader>hs` stage hunk (normal and visual)
- `<leader>hr` reset hunk (normal and visual)
- `<leader>hS` stage buffer
- `<leader>hu` undo stage hunk
- `<leader>hR` reset buffer
- `<leader>hp` preview hunk
- `<leader>hb` blame current line (non-full blame)
- `<leader>hd` diff against index
- `<leader>hD` diff against last commit
- `<leader>tgb` toggle current line blame
- `<leader>tgd` toggle deleted lines
- `ih` text object for hunk (operator-pending and visual)

LazyGit:

- `<leader>gg` opens LazyGit inside Neovim.
- When LazyGit exits (TermClose pattern `*lazygit*`), Neovim runs `checktime` to reload changed files.

## which-key

which-key is enabled with default behavior. Leader-group labels are registered:

- `<leader>c` code
- `<leader>d` document
- `<leader>g` git
- `<leader>r` rename
- `<leader>s` search
- `<leader>w` workspace
- `<leader>t` toggle
- `<leader>tl` toggle LSP
- `<leader>tg` toggle Git
- `<leader>h` Git hunk (normal and visual)

## Dotfiles Context That Affects Neovim

These are outside `~/.config/nvim`, but affect how Neovim is used:

- `EDITOR` is set to `nvim` if available (`~/.config/.exports`).
- Shell function `v()` opens Neovim if installed; fallback to `vi` (`~/.config/.functions`).
- Shell function `sf()` uses `rg` + `fzf` to pick a file and opens it with `v()`.
- Alacritty uses Nightfox terminal colors; Neovim only applies Nightfox when running in Alacritty.
- Tmux config enables true color and is tuned for Neovim (cursor style, terminal overrides).

## Installed but Inactive / Conditional

- `Comment.nvim` is installed but not configured, so no comment toggling keymaps are active.
- `centerpad.nvim` is pinned in `lazy-lock.json` but not declared in `core/plugins.lua`, so it is not loaded.
- `telescope-fzf-native` is conditional: it loads only if `make` is available and the extension builds.

## Pinned Plugin Versions (lazy-lock.json)

These pins are used for reproducibility:

- Comment.nvim: e30b7f2008e52442154b66f7c519bfd2f1e32acb
- LuaSnip: dae4f5aaa3574bd0c2b9dd20fb9542a02c10471c
- blink.cmp: 4b18c32adef2898f95cdef6192cbd5796c1a332d
- centerpad.nvim: 666641d02fd8c58ac401c1fb6bf596bb00b815fb (inactive)
- fidget.nvim: 7fa433a83118a70fe24c1ce88d5f0bd3453c0970
- friendly-snippets: 6cd7280adead7f586db6fccbd15d2cac7e2188b9
- gitsigns.nvim: 9f3c6dd7868bcc116e9c1c1929ce063b978fa519
- indent-blankline.nvim: d28a3f70721c79e3c5f6693057ae929f3d9c0a03
- lazy.nvim: 85c7ff3711b730b4030d03144f6db6375044ae82
- lazydev.nvim: 5231c62aa83c2f8dc8e7ba957aa77098cda1257d
- lazygit.nvim: a04ad0dbc725134edbee3a5eea29290976695357
- lualine.nvim: 47f91c416daef12db467145e16bed5bbfe00add8
- mason-lspconfig.nvim: 21c2a84ce368e99b18f52ab348c4c02c32c02fcf
- mason-tool-installer.nvim: 443f1ef8b5e6bf47045cb2217b6f748a223cf7dc
- mason.nvim: 44d1e90e1f66e077268191e3ee9d2ac97cc18e65
- nightfox.nvim: ba47d4b4c5ec308718641ba7402c143836f35aa9
- nvim-lspconfig: 44acfe887d4056f704ccc4f17513ed41c9e2b2e6
- nvim-treesitter: fcd51bbe9245aa9b79a3930ed9ac42e16e1cf33f
- nvim-treesitter-textobjects: a0e182ae21fda68c59d1f36c9ed45600aef50311
- oil.nvim: f55b25e493a7df76371cfadd0ded5004cb9cd48a
- plenary.nvim: b9fd5226c2f76c951fc8ed5923d85e4de065e509
- telescope-fzf-native.nvim: 6fea601bd2b694c6f2ae08a6c6fab14930c60e2c
- telescope.nvim: a0bbec21143c7bc5f8bb02e0005fa0b982edc026
- vim-fugitive: 61b51c09b7c9ce04e821f6cf76ea4f6f903e3cf4
- vim-rhubarb: 5496d7c94581c4c9ad7430357449bb57fc59f501
- vim-sleuth: be69bff86754b1aa5adcbb527d7fcd1635a84080
- which-key.nvim: 3aab2147e74890957785941f0c1ad87d0a44c15a

## Recreate From Scratch (Checklist)

1. Install Neovim 0.11+.
2. Place the file structure above under `~/.config/nvim`.
3. Ensure required binaries are available: `git`, `rg`, `lazygit`, `make`, Node.js, and Python at the configured `python3_host_prog` path.
4. Launch Neovim once to let `lazy.nvim` install plugins and Mason install LSP servers/tools.
5. Optionally run in Alacritty to apply the Nightfox colorscheme automatically.

This concludes the spec for the current Neovim setup.
