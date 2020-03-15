#!/bin/bash

source $(dirname "$0")/common.sh

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Save screenshots to ~/Pictures/Screenshots
mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Finder stuff
# Don't show anything on the desktop
defaults write com.apple.finder CreateDesktop false

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

killall Finder

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don't auto rearrange spaces
defaults write com.apple.dock mru-spaces -bool false
killall Dock


# Install some stuff I like

# Install homebrew if it isn't installed
installMaybe brew "/usr/bin/ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install some stuff I like
installMaybe zsh "brew install zsh"
installMaybe nvim "brew install neovim"
installMaybe node "brew install node"
installMaybe fuck "brew install thefuck"
installMaybe fzf "brew install fzf"
installMaybe bat "brew install bat"
installMaybe jq "brew install jq"
installMaybe git-standup "brew install git-standup"
installMaybe rg "brew install ripgrep"
installMaybe hub "brew install hub"
installMaybe diff-so-fancy "brew install diff-so-fancy"

# Fixes file watching in jest
installMaybe watchman "brew install watchman"

# Add python to neovim
installMaybe python "brew install python"
installMaybe python3 "brew install python3"
pip2 install neovim --upgrade
pip3 install neovim --upgrade

# Install hack font
brew cask install font-hack

# This adds some helpful services like capitalize/uncapitalize selected text
brew cask install wordservice

# Quick look pluginsssss (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv qlimagesize webpquicklook suspicious-package quicklookase qlvideo
brew cask install provisionql quicklookapk
