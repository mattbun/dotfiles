#!/bin/bash

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


# Install some stuff I like
installMaybe () {
    if ! [ -x "$(command -v $1)" ]; then
        echo "Installing $1"
        eval $2
    else
        echo "$1 is already installed"
    fi
}

# Install homebrew if it isn't installed
installMaybe brew "/usr/bin/ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install some stuff I like
installMaybe zsh "brew install zsh"
installMaybe nvim "brew install neovim"
installMaybe node "brew install node"
installMaybe yarn "brew install yarn"
installMaybe ag "brew install the_silver_searcher"
installMaybe ansible "brew install ansible"
installMaybe fuck "brew install thefuck"

brew cask install caskroom/fonts/font-hack

# Quick look pluginsssss (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package quicklookase qlvideo
brew cask install provisionql quicklookapk