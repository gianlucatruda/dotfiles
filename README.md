# Gianluca's dotfiles

I forked [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles) in 2017 and I've been heavily tuning and personalising mine since then.

My stack:

- Bash as shell
- Ghostty as terminal emulator
- Tmux for multiplexing and as the main terminal compatibility layer
- Neovim as primary editor, with a modular `lazy.nvim` setup originally based on [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim/)
- Vim (with lean `.vimrc`, no plugins) as fallback editor
- Homebrew as package manager
- Karabiner-Elements for modifiers, navigation, and app launchers
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) + `borders` for tiling window management
- Stats for lightweight menu bar system monitoring

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
# Git identity (used by bootstrap.sh)
GIT_USER_EMAIL="name@email.com"
GIT_SIGNING_KEY="<signing_key>"
```

`bootstrap.sh` will apply `git config --global core.editor`, `user.email`, and `user.signingkey` if the variables above are set. Re-run `bootstrap.sh` after changing them.

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

### SSH + GPG agent cache (manual)

Keep keys encrypted but avoid repeated prompts. No macOS Keychain.

SSH key cache for 24h:
```bash
# (Optional) remove existing identity (clears prior TTL)
ssh-add -d ~/.ssh/id_ed25519      
# re-add key with 24h cache
ssh-add -t 24h ~/.ssh/id_ed25519
```
GPG signing cache for 24h:
Add these lines to `~/.gnupg/gpg-agent.conf`
```bash
default-cache-ttl 86400           # cache passphrase for 24h
max-cache-ttl 86400               # cap max cache at 24h
```
Then restart the GPG agent:
```bash
gpgconf --kill gpg-agent && gpgconf --launch gpg-agent
```

Then load up by running `reload`, which is an alias for:
```bash
exec $SHELL -l
```

Note: pyenv is initialized with `--no-rehash` for faster shell startup. Run `pyenv rehash` manually after installing new Python versions or global CLI tools.

---

### Apps to manually install for my workflows

Productivity essentials:
- Zen browser for primary minimalist browsing
- Obsidian for notes and knowledge management
- Shottr for screenshots (macOS only, one-time licence for all features)
- Helium browser for messaging/email web apps

Often helpful:
- spotify for tunes
- todoist for quick capture inbox and basic recurring tasks across devices
- brave-browser for distraction-free YouTube isolated from other browsing
- handbrake for video transcoding
- iina for longer video playback (nicer than VLC on Macs, more GUI than `mpv`)
- obs for screen captures
- anki for making / studying flashcards
- toothfairy for managing bluetooth audio devices

---

## Overview

### Font and colour

- Ghostty is the only terminal config in this repo now; Alacritty is fully deprecated.
- Ghostty uses its built-in `TokyoNight Moon` theme and exports `DOTFILES_TERM=ghostty` as the outer terminal marker.
- tmux provides the runtime contract: `tmux-256color`, RGB enabled for modern `xterm-256color`-style clients, and a status line that mostly keeps terminal defaults.
- Neovim reads that outer terminal marker; tmux refreshes `DOTFILES_TERM` from the attaching client so terminal-specific behavior still works inside tmux.
- [Hack Nerd Font](https://www.nerdfonts.com/font-downloads) for terminal and editor use.


### Structure

Current tracked structure:

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
│   ├── btop
│   │   └── btop.conf
│   ├── git
│   │   └── config
│   ├── ghostty
│   │   └── config
│   ├── homebrew
│   │   └── Brewfile
│   ├── htop
│   │   └── htoprc
│   ├── karabiner
│   │   ├── complex_modifications
│   │   │   └── 1584620783.json
│   │   └── karabiner.json
│   ├── lf
│   │   ├── colors
│   │   ├── icons
│   │   └── lfrc
│   ├── nvim
│   │   ├── SPEC.md
│   │   ├── init.lua
│   │   ├── lazy-lock.json
│   │   └── lua
│   │       ├── core
│   │       │   ├── keymaps.lua
│   │       │   ├── options.lua
│   │       │   ├── path.lua
│   │       │   ├── plugins.lua
│   │       │   └── terminal.lua
│   │       └── plugin_config
│   │           ├── blink.lua
│   │           ├── colourscheme.lua
│   │           ├── gitsigns.lua
│   │           ├── ibl.lua
│   │           ├── init.lua
│   │           ├── lazydev.lua
│   │           ├── lazygit.lua
│   │           ├── lsp.lua
│   │           ├── lualine.lua
│   │           ├── oil.lua
│   │           ├── telescope.lua
│   │           └── treesitter.lua
│   ├── ranger
│   │   └── rc.conf
│   ├── stats
│   │   └── Stats.plist
│   ├── tmux
│   │   └── tmux.conf
│   └── zen
│       └── zen-keyboard-shortcuts.json
├── .gitignore
├── .gitignore_global
├── .vimrc
├── AGENTS.md
├── bootstrap.sh
├── brew.sh
├── macos.sh
└── scripts
    ├── gt-btooth
    ├── gt-cheat
    ├── gt-perfprofile
    ├── gt-scan
    ├── gt-stt
    ├── gt-sync-homelab
    ├── gt-sync-obsidian
    ├── gt-synchdd
    ├── gt-todoist-export
    └── gt-tts
```


### Bash functions

- **`v()`**: Opens the current directory or a specified directory in neovim if available, otherwise uses vi.
- **`sf()`**: Searches for text-readable, non-hidden files (or all files including hidden with `-a` flag, excluding `.git`) in the current directory using `rg` and `fzf`, then opens the selected file in Vim.
- **`sd()`**: Searches directories using `fzf` and changes to the selected directory, excluding paths containing `.git`.
- **`update_environment_from_tmux()`**: Refreshes tmux-managed environment variables when a shell is started or reloaded inside tmux.
- **`mkd()`**: Creates a new directory (and any necessary parent directories) then changes into it.
- **`fs()`**: Displays the size of a file or total size of a directory using `du`, presenting results in human-readable form.
- **Built-in Overridden `diff()`**: Uses Git’s colored diff functionality when Git is installed, otherwise falls back to standard behavior.
- **`o()`**: Opens the current directory or a specified file/directory with the default system application.
- **`tre()`**: Runs the `tree` command showing hidden files and colorizing the output (ignoring `.git`, `node_modules`, and `bower_components` directories) and pipes the results to `less` with options to keep colors and line numbers.

### Neovim setup

Neovim prepends Mason's `bin` to PATH so LSP/tools use Mason-managed binaries
inside Neovim without affecting your shell.

Markdown formatting uses Prettier (via Mason) when you run `<leader>f` or `:Format`.

Theme behavior stays intentionally simple: Neovim only enables `Tokyo Night Moon` in Ghostty; other terminals keep their own palette.

Neovim highlights:
- LSP UI toggles live under `<leader>tl` (diagnostics, virtual text, inlay hints, Ty workspace) with `<leader>tla` for all.
- Completion auto-trigger toggle lives at `<leader>tc`.
- Winbar shows git-root-relative paths (fallback to CWD), and `<leader><tab>` jumps to the most recent buffer.

See `.config/nvim/SPEC.md` for the full behavior-level spec.

```
.config/nvim/
├── SPEC.md
├── init.lua
├── lazy-lock.json
└── lua
    ├── core
    │   ├── keymaps.lua
    │   ├── options.lua
    │   ├── path.lua
    │   ├── plugins.lua
    │   └── terminal.lua
    └── plugin_config
        ├── blink.lua
        ├── colourscheme.lua
        ├── gitsigns.lua
        ├── ibl.lua
        ├── init.lua
        ├── lazydev.lua
        ├── lazygit.lua
        ├── lsp.lua
        ├── lualine.lua
        ├── oil.lua
        ├── telescope.lua
        └── treesitter.lua
```
