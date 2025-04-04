#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude "*.sh" \
		--exclude "*.md" \
		--exclude "*.txt" \
		--exclude ".extra" \
		--exclude ".gitignore" \
		--exclude ".aider*" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
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
unset doIt;
