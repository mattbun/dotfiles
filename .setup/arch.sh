#!/bin/bash

# TODO install yay (or some other aur tool)

source $(dirname "$0")/common.sh

installPacman () {
  if [ $# -eq 1 ]; then
    installMaybe $1 "sudo pacman --noconfirm -S $1"
  else
    installMaybe $1 "sudo pacman --noconfirm -S $2"
  fi
}


# Sync pacman database
sudo pacman -Syy

# Install yq so we can use the installPackages script
installMaybe go "sudo pacman -S --noconfirm go"
installMaybe yq "GO111MODULE=on go get github.com/mikefarah/yq/v3"

# Install my favorite things
PLATFORM=arch ~/.setup/installPackages.sh

# set default shell to zsh
sudo chsh -s /usr/bin/zsh $USER

echo "All done!"
