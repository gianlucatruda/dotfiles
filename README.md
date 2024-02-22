# Gianluca's macOS dotfiles

## Refactor TODOs
- [ ] .extra streamlined, only secrets, called at the end.
- [ ] Integrate `.exports` to somewhere else.
- [ ] .bash_profile tidied, reorganised
- [ ] Most of `.functions` isn't stuff I use. Refactor and integrate into `.bash_profile` ?
- [ ] Full refactor of `.macos` init script.
- [ ] Full refactor and test of `bootstrap.sh` initialisation script.
- [ ] Deal with persisting `pyenv not found` on shell startup


95% stolen from <a href="https://github.com/mathiasbynens/dotfiles">Mathias</a>

### Configuring a new Mac

After cloning the repo:

```bash
cd dotfiles
source bootstrap.sh
./.macos
```
Install vundle and re-source
```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
source bootstrap.sh
```

Configure the `~/.extra` file

```bash
# Git credentials
GIT_AUTHOR_NAME="Gianluca Truda"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="x@y.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
git config --global commit.gpgsign true
git config --global user.signingkey <signing key>

# Environment variables etc. below...

```


## Original Author

[Mathias Bynens](https://mathiasbynens.be/)
