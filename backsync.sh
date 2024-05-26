#!/usr/bin/env bash

# Set directory to where dotfiles are
cd "$(dirname "${BASH_SOURCE}")";

brew list > .config/homebrew/brew-packages.txt
brew list --casks > .config/homebrew/brew-casks.txt
echo "Synchronised .config/homebrew/"
