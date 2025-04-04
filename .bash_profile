
# Set XDG_CONFIG_HOME for most configs
export XDG_CONFIG_HOME="$HOME"/.config

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in "${XDG_CONFIG_HOME}"/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

if [[ "$(uname)" == "Darwin" ]] && [[ -x /opt/homebrew/bin/brew ]]; then
  # Make sure homebrew is happy
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ "$(uname)" == "Darwin" ]] && declare -f update_environment_from_tmux >/dev/null; then
  update_environment_from_tmux
fi
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;
# Append to the Bash history file, rather than overwriting it
shopt -s histappend;
# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Set git editor to value of EDITOR set in .exports
git config --global core.editor "$EDITOR"

# Use vim keybindings to edit lines in bash (with 'readline' library)
set -o vi

export LSCOLORS=cxgxfxexbxegedabagacad

# Reset cursor style to vertical bar
reset-cursor() {
  printf '\033]50;CursorShape=1\x7'
}
export PS1="$(reset-cursor)$PS1"

# iTerm shell integration
#test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Set up fzf key bindings and fuzzy completion
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi

# Zoxide integration with Bash
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# Pyenv integration with Bash
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
