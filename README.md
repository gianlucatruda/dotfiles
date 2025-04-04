# Gianluca's dotfiles

Heavily modified adaptation of [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles) that I've personalised since 2017.

My stack:

- Homebrew as package manager
- Alacritty as terminal
- Bash as shell
- Tmux for multiplexing
- Neovim as primary editor, based off [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim/)
- Karabiner for key modifiers and custom keybindings
- Vim (with lean .vimrc, no plugins) as fallback editor
- [Aerospace](https://github.com/nikitabobko/AeroSpace) as (tiling) window manager (with [tweaks](https://youtu.be/-FoWClVHG5g))

<img width="1840" alt="SCR-20250404-pesw" src="https://github.com/user-attachments/assets/2120218b-0845-46c8-91de-7d778d8e871e" />

<img width="1840" alt="SCR-20250404-pfzx" src="https://github.com/user-attachments/assets/a50332f4-aaa4-47d6-9051-c02832264693" />

<img width="1840" alt="SCR-20250404-pfxu" src="https://github.com/user-attachments/assets/eae9e7c9-a009-427f-ab7c-b5f41f82cbae" />

---

## Installation

With Git:
```bash
git clone git@github.com:gianlucatruda/dotfiles.git
cd dotfiles
```

### System agnostic bootstrap

```bash
cd dotfiles
source bootstrap.sh
```

Create the `~/.config/.extra` file:
```bash
echo "" >> ~/.config/.extra
```

Add the following details (and any other system-wide variables):
```bash
# Git credentials
GIT_AUTHOR_NAME="Your Name"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="name@email.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global user.email "$GIT_AUTHOR_EMAIL"
git config --global commit.gpgsign true
git config --global user.signingkey <signing key>
```

Then load up by running `reload`, which is an alias for:

```bash
exec $SHELL -l
```

### Mac-specific setup

Configure some macOS preferences:
```bash
./macos.sh
```

Install macOS packages with Homebrew:
```bash
./brew.sh
```

#### Keeping homebrew synced with dotfiles

Update the dotfiles repo from the system:
```bash
cd <your-dotfiles-repo>
brew bundle dump --all --describe --force --file .config/homebrew/Brewfile
```

Update the system from the dotfiles repo:
```bash
cd <your-dotfiles-repo>
source bootstrap.sh 
brew bundle install -v --cleanup --force --file ~/.config/homebrew/Brewfile
```

Note: you can also install, cleanup, upgrade in steps:
```bash
brew bundle install --no-upgrade --file ~/.config/homebrew/Brewfile
brew bundle cleanup --force --file ~/.config/homebrew/Brewfile
brew bundle install --file ~/.config/homebrew/Brewfile
```

---

## TODOs

- [ ] Migrate apps to be installed with Homebrew
  - [ ] karabiner-elements
- [ ] Make a list of favoured "manual install" apps
  - [ ] anki
  - [ ] blender
  - [ ] brave-browser
  - [ ] handbrake
  - [ ] hex-fiend
  - [ ] iina
  - [ ] libreoffice
  - [ ] obs
  - [ ] obsidian
  - [ ] shottr
  - [ ] spotify
  - [ ] tad (looking for nice TUI alt.)
  - [ ] todoist
  - [ ] toothfairy

---

## Overview

### Font and colour

- [Nightfox](https://github.com/EdenEast/nightfox.nvim/tree/main) colorscheme (both alacritty and nvim).
- [UbuntuMono](https://www.programmingfonts.org/#ubuntu) with [Nerd font icons](https://www.nerdfonts.com).


### Structure 

Generate with:

```bash
tree -a -L 3 --gitignore -I .git/ -I .gitignore -I README.md
```

```
.
├── .bash_profile
├── .bashrc
├── .config
│   ├── .aliases
│   ├── .bash_prompt
│   ├── .exports
│   ├── .functions
│   ├── .inputrc
│   ├── .path
│   ├── aerospace
│   │   └── aerospace.toml
│   ├── alacritty.toml
│   ├── git
│   │   └── config
│   ├── homebrew
│   │   └── Brewfile
│   ├── htop
│   │   └── htoprc
│   ├── karabiner
│   │   ├── assets
│   │   ├── complex_modifications
│   │   └── karabiner.json
│   ├── lf
│   │   ├── colors
│   │   ├── icons
│   │   └── lfrc
│   ├── newsboat
│   │   └── config
│   ├── nvim
│   │   └── init.lua
│   ├── spotify-player
│   │   └── app.toml
│   └── tmux
│       └── tmux.conf
├── .gitignore_global
├── .vimrc
├── bootstrap.sh
├── brew.sh
├── macos.sh
└── scripts
    ├── gt-btooth
    ├── gt-cheat
    ├── gt-scan
    ├── gt-stt
    ├── gt-sync-obsidian
    ├── gt-synchdd
    └── gt-tts

15 directories, 33 files
```


### Bash functions

- **`v()`**: Opens the current directory or a specified directory in neovim if available, otherwise uses vi.
- **`sf()`**: Searches for text-readable, non-hidden files (or all files including hidden with `-a` flag, excluding `.git`) in the current directory using `rg` and `fzf`, then opens the selected file in Vim.
- **`sd()`**: Searches directories using `fzf` and changes to the selected directory, excluding paths containing `.git`.
- **`update_environment_from_tmumx()`**: Updates the environment variables in tmux if running inside a tmux session.
- **`mkd()`**: Creates a new directory (and any necessary parent directories) then changes into it.
- **`fs()`**: Displays the size of a file or total size of a directory using `du`, presenting results in human-readable form.
- **Built-in Overridden `diff()`**: Uses Git’s colored diff functionality when Git is installed, otherwise falls back to standard behavior.
- **`unidecode()`**: Decodes Unicode escape sequences in the format `\x{ABCD}` and outputs them.
- **`o()`**: Opens the current directory or a specified file/directory with the default system application.
- **`tre()`**: Runs the `tree` command showing hidden files and colorizing the output (ignoring `.git`, `node_modules`, and `bower_components` directories) and pipes the results to `less` with options to keep colors and line numbers.

### NeoVim setup

(Generated by GPT-4-turbo, based on my `init.lua`)

- **`lazy.nvim`**: A plugin manager to organize and manage Neovim plugins.
- **`tpope/vim-fugitive` and `tpope/vim-rhubarb`**: Tools for Git integration, providing commands for various Git operations directly within the editor.
- **`tpope/vim-sleuth`**: Automatically adjusts `tabstop` and `shiftwidth` based on the file contents.
- **`neovim/nvim-lspconfig`**: Configuration framework for Neovim's built-in LSP (Language Server Protocol).
- **`williamboman/mason.nvim`, `williamboman/mason-lspconfig.nvim`**: Tools for managing LSP servers, ensuring they are installed and up-to-date.
- **`j-hui/fidget.nvim`**: Provides a graphical indicator to display LSP progress information.
- **`folke/neodev.nvim`**: Enhances Neovim's Lua development experience by providing improved support and configurations specific to Neovim's API.
- **`hrsh7th/nvim-cmp`, various related plugins** (`L3MON4D3/LuaSnip`, `saadparwaiz1/cmp_luasnip`, etc.): Autocompletion framework setup with integrations for snippets, LSP, paths, and common programming constructs.
- **`folke/which-key.nvim`**: Helps discover keybindings by showing a popup with possible keybindings as you type.
- **`lewis6991/gitsigns.nvim`**: Adds Git-related information to the sign column (like added/changed lines) and provides commands for interacting with Git hunks.
- **`smithbm2316/centerpad.nvim`**: Provides padding to center the text within the editor window for a more focused writing/reading experience.
- **`nvim-lualine/lualine.nvim`**: A lightweight and configurable status line solution.
- **`lukas-reineke/indent-blankline.nvim`**: Adds indentation guides to empty lines.
- **`numToStr/Comment.nvim`**: Simplifies the task of commenting and uncommenting code lines or blocks.
- **`nvim-telescope/telescope.nvim`**, including the `plenary.nvim` and `fzf-native` plugins: An extendable fuzzy finder over lists that can be used to locate files, grep for strings, manage LSP sessions, and more.
- **`nvim-treesitter/nvim-treesitter`**: Enables advanced syntax highlighting, better filetype detection, and additional text manipulation features through its parsing library.
- **Leader Key**: The space ( `' '` ) key is configured as the leader key, pivotal for many custom shortcuts.
- **Colorscheme**: `nightfox.nvim` is set as the default theme, indicating an emphasis on visual aesthetics.
- **Clipboard**: Synchronized with the system clipboard, promoting easy copy-paste operations between Neovim and other applications.
