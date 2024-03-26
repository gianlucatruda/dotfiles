# Gianluca's dotfiles

Heavily modified adaptation of [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles) that I've personalised since 2017.

---

## Refactor TODOs
- [x] .extra streamlined, only secrets, called at the end.
- [x] Integrate `.exports` to somewhere else.
- [x] Integrate `.inputrc` to somewhere else? And tidy up.
- [x] .bash_profile tidied, reorganised
- [x] Full refactor of `.macos` init script.
- [x] Refactor `.aliases`
- [x] Make sure all instances that refer to the home path use `$HOME` instead.
- [x] Most of `.functions` isn't stuff I use. Refactor and integrate into `.bash_profile` ?
- [x] Full refactor and test of `bootstrap.sh` initialisation script.
- [x] Where can everything live? `XDG_CONFIG_HOME`?
- [x] Fix git signing and authoring issues
- [-] Dotfiles management
  - Look into dotfiles management tools: `stow`, `chezmoi`, `yadm`. -> None are installed by default and all require a fair bit of config.
  - Use a [bare git repo](https://www.atlassian.com/git/tutorials/dotfiles) -> complex aliasing, weird vibes, clunky and specific initial config.
  - Symlink the actual dotfiles repo? See [here](https://github.com/mischavandenburg/dotfiles/blob/e417b14bdfa2a8fd54183944c8d1cd6095fa88bb/setup#L23)
- [x] Incorporate new NeoVim setup
- [x] Make `reload` alias system agnostic: already is: `exec $SHELL -l`
- [x] Fix alacritty font rendering (in Tmux)
- [x] Customise nvim setup. Lean
- [x] Tidy nvim plugins and streamline
- [x] "Migrate" `.vimrc` setup from vim to `init.lua` setup for nvim (honestly unnecessary, as kickstart.nvim is mostly to my liking already).
- [x] Fix colours of `git status` (modified different from deleted)
- [x] Fix htop config to sort by CPU util desc.
- [x] Deal with persisting `pyenv not found` on shell startup
- [x] Install neovim LSPs for favourite languages with Mason
- [x] Ensure `bootstrap.sh` is idempotent (running it multiple times doesn't cause issues).
- [ ] Get linters and formatters configured for nvim (Mason)
  - [ ] nvim-lint
  - [ ] formatter.nvim
- [ ] Neovim tweaks (see [this video](https://youtu.be/w7i4amO_zaE)):
  - [ ] Harpoon for moving between marks rapidly
  - [ ] Undo tree for undo history 
  - [ ] Neo-tree for file tree
- [-] Write `backsync.sh`, the inverse of `bootstrap.sh`, to rsync dotfiles changes back to repo
- [-] Document structure, supported tools, and "philosophy"
- [ ] Have a look at [dotfiles.github.io](https://dotfiles.github.io/) for more ideas
- [ ] Look into [mackup](https://github.com/lra/mackup) for keeping application settings in sync.
- [ ] Test on Linux (and another mac)
- [ ] Publish repo publicly (and document at [gianluca.ai](http://gianluca.ai))

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
- iTerm (now favouring alacritty)
- neoVim (in progress)
  - Packer: Plugin/package management for Neovim.
  - Lazy.nvim : How does this compare or build atop Packer?
  - Mason: Plugin for managing language servers (via LSP)
  - Telescope
  - Treesitter
  - Centerpad


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
│   ├── .homebrew
│   │   ├── brew-casks.txt
│   │   ├── brew-packages.txt
│   │   └── brew.sh
│   ├── .inputrc
│   ├── .iterm_config
│   │   ├── Default.json
│   │   ├── com.googlecode.iterm2.plist
│   │   └── gianluca_custom.itermcolors
│   ├── .macos
│   ├── .path
│   ├── .vscode
│   │   ├── keybindings.json
│   │   └── settings.json
│   ├── alacritty.toml
│   ├── git
│   │   └── config
│   ├── htop
│   │   └── htoprc
│   ├── karabiner
│   │   ├── complex_modifications
│   │   └── karabiner.json
│   ├── nvim
│   │   └── init.lua
│   └── tmux
│       └── tmux.conf
├── .vimrc
├── backsync.sh
└── bootstrap.sh

11 directories, 26 files
```


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
GIT_AUTHOR_NAME="Gianluca Truda"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="x@y.com"
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

Currently this just dumps homebrew package and cask lists to text files in `.config/.homebrew/`

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

