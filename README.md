# Gianluca's dotfiles

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
- [-] `git config <...>` -> Where should those live?
- [ ] Deal with persisting `pyenv not found` on shell startup
- [ ] symlink the actual dotfiles repo?
- [ ] Set a custom default wallpaper in `.macos`

Heavily modified adaptation of <a href="https://github.com/mathiasbynens/dotfiles">Mathias's dotfiles</a> that I've personalised since 2017.

### Configuring a new Mac

After cloning the repo:

Create the `~/.config/.extra` file

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

```bash
cd dotfiles
source bootstrap.sh
./.macos
```
