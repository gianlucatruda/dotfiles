#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";
dotfiles_repo_root="$(pwd -P)";

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude "*.sh" \
		--include ".config/agents/shared/skills/***" \
		--exclude "*.md" \
		--exclude "*.txt" \
		--exclude ".extra" \
		--exclude ".gitignore" \
		--exclude ".aider*" \
		--exclude "docs/" \
		-avh --no-perms . ~;
	rsync -a --no-perms .config/agents/shared/AGENTS.md ~/.config/agents/shared/;
	printf '%s\n' "$dotfiles_repo_root" > ~/.config/.dotfiles-root;
	jq -r '.deployments[] | [.source, .target] | @tsv' ~/.config/agents/harnesses.json |
	while IFS=$'\t' read -r source target; do
		source_path="$HOME/.config/agents/$source"
		target_path="$HOME/$target"

		if [[ -d "$source_path" ]]; then
			mkdir -p "$target_path"
			rsync -a --no-perms "$source_path/" "$target_path/"
		else
			mkdir -p "$(dirname "$target_path")"
			rsync -a --no-perms "$source_path" "$target_path"
		fi
	done
	source ~/.bash_profile;
	# Rebuild pyenv shims once after bootstrapping (skip if pyenv isn't installed)
	if command -v pyenv >/dev/null 2>&1 && [[ -d "$HOME/.pyenv/shims" ]]; then
		pyenv rehash
	fi
	# Apply git defaults from ~/.config/.extra without running git on every shell startup
	if command -v git >/dev/null 2>&1; then
		# Prefer EDITOR from .exports; only set if defined
		if [[ -n "$EDITOR" ]]; then
			git config --global core.editor "$EDITOR"
		fi
		# Set identity and signing only when variables are present
		if [[ -n "$GIT_USER_EMAIL" ]]; then
			git config --global user.email "$GIT_USER_EMAIL"
		fi
		if [[ -n "$GIT_SIGNING_KEY" ]]; then
			git config --global user.signingkey "$GIT_SIGNING_KEY"
		elif [[ -n "$GI_SIGNING_KEY" ]]; then
			git config --global user.signingkey "$GI_SIGNING_KEY"
		fi
	fi
}

# If --force or -f argument, skip the y/n confirmation
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt dotfiles_repo_root;
