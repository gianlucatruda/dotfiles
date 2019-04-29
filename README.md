# Gianluca's macOS dotfiles

95% stolen from <a href="https://github.com/mathiasbynens/dotfiles">Mathias</a>

![Screenshot of shell prompt](http://i.imgur.com/cnhiK09.png)

### Configuring a new Mac

After cloning the repo:

```bash
cd dotfiles
source bootstrap.sh
./.macos
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
