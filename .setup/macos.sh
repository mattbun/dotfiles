#!/bin/bash

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
