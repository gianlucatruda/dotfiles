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
- [ ] Fix colours of `git status` (modified different from deleted)
- [ ] Fix htop config to sort by CPU util desc.
- [ ] Ensure `bootstrap.sh` is idempotent (running it multiple times doesn't cause issues).
- [ ] Deal with persisting `pyenv not found` on shell startup
  - NeoVim's `:checkhealth` might help
- [ ] Test on Linux (and another mac)
- [ ] Document structure, supported tools, and "philosophy"
- [ ] Publish repo publicly (and document at [gianluca.ai](http://gianluca.ai))


Helpful trick to list all lazy-installed plugins in a readible format (uses `jq`):

```bash
cat ~/.config/nvim/lazy-lock.json | jq 'keys'
```

---

## Explanation

### Tools 

- BASH
- Tmux 
- Vim (with lean .vimrc, no plugins)
- Karabiner
- Homebrew
- Alacritty
- htop (and btm)
- iTerm (now favouring alacritty)
- neoVim (TODO in progress)
  - Packer: Plugin/package management for Neovim.
  - Lazy.nvim : How does this compare or build atop Packer?
  - Mason: Plugin for managing language servers (via LSP)


### Structure (TODO update, automate?)

 ```
 .config
├── .aliases
├── .bash_prompt
├── .exports
├── .functions
├── .gitconfig
├── .homebrew
│   ├── brew-casks.txt
│   ├── brew-packages.txt
│   └── brew.sh
├── .inputrc
├── .iterm_config
│   ├── Default.json
│   ├── com.googlecode.iterm2.plist
│   └── gianluca_custom.itermcolors
├── .macos
├── .path
├── .vscode
│   ├── keybindings.json
│   └── settings.json
├── htop
│   └── htoprc
├── karabiner
│   ├── complex_modifications
│   └── karabiner.json
└── nvim
    ├── .gitignore
    ├── .neoconf.json
    ├── README.md
    ├── init.lua
    ├── lazy-lock.json
    ├── lazyvim.json
    ├── lua
    └── stylua.toml
 
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
~/.config/.macos
```

