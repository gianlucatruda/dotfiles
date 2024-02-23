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
- [ ] Deal with persisting `pyenv not found` on shell startup
  - [ ] NeoVim's `:checkhealth` might help
- [ ] Dotfiles management
  - [-] Look into dotfiles management tools: `stow`, `chezmoi`, `yadm`. -> None are installed by default and all require a fair bit of config.
  - [-] Use a [bare git repo](https://www.atlassian.com/git/tutorials/dotfiles) -> complex aliasing, weird vibes, clunky and specific initial config.
  - [ ] symlink the actual dotfiles repo? See [here](https://github.com/mischavandenburg/dotfiles/blob/e417b14bdfa2a8fd54183944c8d1cd6095fa88bb/setup#L23)
- [x] Incorporate new NeoVim setup
- [x] Make `reload` alias system agnostic: already is: `exec $SHELL -l`
- [ ] Ensure `bootstrap.sh` is idempotent (running it multiple times doesn't cause issues).
- [ ] Test on Linux (and another mac)
- [ ] Squash commit histories down, streamline `master` branch so everything is lean
- [ ] Document structure, supported tools, and "philosophy"
- [ ] Publish repo publicly (and document at [gianluca.ai](http://gianluca.ai))


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

