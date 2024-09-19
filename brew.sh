#!/usr/bin/env bash

# You probably only want to run this when setting up a new Mac, after running .macos
# ----------------------------------------------------------------------------------

read -p "This will (un)install packages on your system. Are you sure? (y/n) " -n 1;
echo "";
if ![[ $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi;
# # Ask for the administrator password upfront
# sudo -v
# # Keep-alive: update existing `sudo` time stamp until `.macos` has finished
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done &

# Make sure we’re using the latest Homebrew.
brew update
# Upgrade any already-installed formulae.
brew upgrade
# Install a modern version of Bash.
brew install bash
brew install bash-completion2
# Install GNU core utilities (those that come with macOS are outdated).
brew install coreutils

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)
# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install `wget` with IRI support.
brew install wget --with-iri
# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install tmux
brew install php
brew install gmp

# ---------------------------------------------------------------------------------

BREWPATH="$HOME/.config/homebrew/Brewfile"
if ! [[ -n $BREWPATH && -e "$BREWPATH" ]]; then
	echo "Brewfile not found in $BREWPATH"
	exit 1
fi
echo "Installing / upgrading from $BREWPATH ..."
brew bundle install --cleanup --force --file $BREWPATH
exit 0
