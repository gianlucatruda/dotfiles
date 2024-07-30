# Gianluca's dotfiles

Heavily modified adaptation of [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles) that I've personalised since 2017.

---

## TODOs
- [ ] Neovim tweaks (see [this video](https://youtu.be/w7i4amO_zaE)):
  - [ ] Harpoon for moving between marks rapidly
  - [ ] Undo tree for undo history 
  - [ ] Neo-tree for file tree
- [ ] Document structure, supported tools, and "philosophy"
- [ ] Have a look at [dotfiles.github.io](https://dotfiles.github.io/) for more ideas
- [ ] Look into [mackup](https://github.com/lra/mackup) for keeping application settings in sync.
- [ ] Test on Linux (and another mac)
- [ ] Publish repo publicly (and document at [gianluca.ai](http://gianluca.ai))
- [ ] Incorporate [lf-gadgets](https://github.com/slavistan/lf-gadgets)

---

## Explanation

### Tools 

- BASH
- Tmux 
- Vim (with lean .vimrc, no plugins)
- Karabiner
- Homebrew
- Alacritty
- htop
- neoVim (as primary editor)
  - Packer: Plugin/package management for Neovim.
  - Lazy.nvim : How does this compare or build atop Packer?
  - Mason: Plugin for managing language servers (via LSP)
  - Telescope
  - Treesitter
  - Centerpad

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
│   ├── .macos
│   ├── .path
│   ├── alacritty.toml
│   ├── git
│   │   └── config
│   ├── homebrew
│   │   ├── brew-casks.txt
│   │   ├── brew-packages.txt
│   │   └── brew.sh
│   ├── htop
│   │   └── htoprc
│   ├── karabiner
│   │   ├── complex_modifications
│   │   └── karabiner.json
│   ├── lf
│   │   ├── colors
│   │   ├── icons
│   │   └── lfrc
│   ├── nvim
│   │   └── init.lua
│   └── tmux
│       └── tmux.conf
├── .vimrc
├── backsync.sh
├── bootstrap.sh
└── scripts
    ├── btooth
    ├── cheat
    ├── scan
    ├── stt
    └── tts

```

## Bash functions

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

## Migrating apps to homebrew

Things I have installed and use, but which aren't managed by Homebrew (yet).

- [ ] anki
- [ ] blender
- [ ] brave-browser
- [ ] docker
- [ ] firefox
- [ ] handbrake
- [ ] hex-fiend
- [ ] iina
- [ ] imageoptim
- [ ] karabiner-elements
- [ ] libreoffice
- [ ] obs
- [ ] obsidian
- [ ] shottr
- [ ] spectacle
- [ ] spotify
- [ ] tad
- [ ] todoist
- [ ] toothfairy
- [ ] transmission
- [ ] vcv-rack
- [x] alacritty
- [x] ferdium
- [x] kap
- [x] qlmarkdown
- [x] syntax-highlight
- [x] vscodium


## Installation

```
git clone git@github.com:gianlucatruda/dotfiles.git
```

## Setup / update 

```bash
cd dotfiles
source bootstrap.sh
```

Create the `~/.config/.extra` file:

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

```bash
source ~/.config/.macos
```

### Backsync (in progress)

Currently this just dumps homebrew package and cask lists to text files in `.config/homebrew/`

```bash
source backsync.sh
```

---

## Notes

From `h: mason-quickstart`:
> Although many packages are perfectly usable out of the box through Neovim
builtins, it is recommended to use other 3rd party plugins to further
integrate these. The following plugins are recommended:
  -   LSP: `lspconfig` & `mason-lspconfig.nvim`
  -   DAP: `nvim-dap` & `nvim-dap-ui`
  -   Linters: `null-ls.nvim` or `nvim-lint`
  -   Formatters: `null-ls.nvim` or `formatter.nvim`

  formatter.nvim        https://github.com/mhartington/formatter.nvim
  lspconfig             https://github.com/neovim/nvim-lspconfig
  mason-lspconfig.nvim  https://github.com/williamboman/mason-lspconfig.nvim
  null-ls.nvim          https://github.com/jose-elias-alvarez/null-ls.nvim
  nvim-dap              https://github.com/mfussenegger/nvim-dap
  nvim-dap-ui           https://github.com/rcarriga/nvim-dap-ui
  nvim-lint             https://github.com/mfussenegger/nvim-lint


Helpful trick to list all lazy-installed plugins in a readible format (uses `jq`):

```bash
cat ~/.config/nvim/lazy-lock.json | jq 'keys'
```

