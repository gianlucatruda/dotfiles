# Gianluca's dotfiles

I forked [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles) in 2017 and I've been heavily tuning and personalising mine since then.

My stack:

- Bash as shell
- Tmux for multiplexing
- Neovim as primary editor, based off [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim/)
- Vim (with lean .vimrc, no plugins) as fallback editor
- Alacritty as terminal
- Homebrew as package manager
- Karabiner for key modifiers and custom keybindings
- [Aerospace](https://github.com/nikitabobko/AeroSpace) as (tiling) window manager (with [tweaks](https://youtu.be/-FoWClVHG5g))

<img width="1840" alt="SCR-20250404-pesw" src="https://github.com/user-attachments/assets/2120218b-0845-46c8-91de-7d778d8e871e" />

<img width="1840" alt="SCR-20250404-pfzx" src="https://github.com/user-attachments/assets/a50332f4-aaa4-47d6-9051-c02832264693" />

<img width="1840" alt="SCR-20250404-pfxu" src="https://github.com/user-attachments/assets/eae9e7c9-a009-427f-ab7c-b5f41f82cbae" />

---

## Installation

With Git:
```bash
git clone --depth 5 git@github.com:gianlucatruda/dotfiles.git <your/dotfiles/path/>
```
(I suggest `~/dotfiles` for the path)

Or with curl:

```bash
curl -L -o dotfiles-master.zip https://github.com/gianlucatruda/dotfiles/archive/master.zip
unzip dotfiles-master.zip
cd dotfiles-master
```

### System agnostic bootstrap

From within the dotfiles directory:

```bash
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

Install packages with Homebrew:
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

#### Additional tooling / packages

`llm` plugins re-installed with update:

```bash
brew update && brew upgrade llm && llm install -U llm-anthropic llm-ollama
```

#### Manually syncing zen browser config files

Manually check the local path (even on macOS) and use your `<profile_code>`, as this path may change (which is why I just do it manually. It's more of a backup than a true config).

Sync browser to dotfiles (from within local `dotfiles` repo):
```bash
cp ~/Library/Application\ Support/zen/Profiles/<profile_code>.Default\ \(release\)/zen-keyboard-shortcuts.json .config/zen/zen-keyboard-shortcuts.json
```

Sync browser from dotfiles:
```bash
cp .config/zen/zen-keyboard-shortcuts.json ~/Library/Application\ Support/zen/Profiles/<profile_code>.Default\ \(release\)/zen-keyboard-shortcuts.json 
```

Note: Zen always re-formats the file, so it's a messy and manual backup more than a reliable config.

---

### Apps to manually install for my workflows

Productivity essentials:
- Zen browser for primary minimalist browsing
- Obsidian for notes and knowledge management
- Shottr for screenshots (macOS only, one-time licence for all features)
- Helium browser for messaging/email web apps
- tad (switching to [visidata](https://github.com/saulpw/visidata) and [csvlens](https://github.com/YS-L/csvlens))

Often helpful:
- spotify for tunes
- todoist for quick capture inbox and basic recurring tasks across devices
- menubar stats (App store) 
- brave-browser for distraction-free YouTube isolated from other browsing
- handbrake for video transcoding
- iina for longer video playback (nicer than VLC on Macs, more GUI than `mpv`)
- obs for screen captures
- anki for making / studying flashcards
- toothfairy for managing bluetooth audio devices

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
│   ├── nvim
│   │   ├── init.lua
│   │   └── lua
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
    ├── gt-todoist-export
    └── gt-tts

14 directories, 32 files
```


### Bash functions

- **`v()`**: Opens the current directory or a specified directory in neovim if available, otherwise uses vi.
- **`sf()`**: Searches for text-readable, non-hidden files (or all files including hidden with `-a` flag, excluding `.git`) in the current directory using `rg` and `fzf`, then opens the selected file in Vim.
- **`sd()`**: Searches directories using `fzf` and changes to the selected directory, excluding paths containing `.git`.
- **`update_environment_from_tmumx()`**: Updates the environment variables in tmux if running inside a tmux session.
- **`mkd()`**: Creates a new directory (and any necessary parent directories) then changes into it.
- **`fs()`**: Displays the size of a file or total size of a directory using `du`, presenting results in human-readable form.
- **Built-in Overridden `diff()`**: Uses Git’s colored diff functionality when Git is installed, otherwise falls back to standard behavior.
- **`o()`**: Opens the current directory or a specified file/directory with the default system application.
- **`tre()`**: Runs the `tree` command showing hidden files and colorizing the output (ignoring `.git`, `node_modules`, and `bower_components` directories) and pipes the results to `less` with options to keep colors and line numbers.

### Neovim setup

```
.config/nvim/
├── init.lua
└── lua
    ├── core
    │   ├── keymaps.lua
    │   ├── options.lua
    │   └── plugins.lua
    └── plugin_config
        ├── cmp.lua
        ├── colourscheme.lua
        ├── gitsigns.lua
        ├── ibl.lua
        ├── init.lua
        ├── lsp.lua
        ├── lualine.lua
        ├── neodev.lua
        ├── telescope.lua
        └── treesitter.lua

4 directories, 14 files
```
