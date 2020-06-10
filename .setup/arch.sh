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

# Some prerequisites to install other things
installPacman curl
installPacman git
installPacman pip python-pip

# zsh
installPacman zsh

# neovim with python support
installPacman nvim neovim
pip3 install --user neovim

# some extras
installPacman fzf
installPacman rg ripgrep
installPacman bat
installPacman diff-so-fancy
installPacman htop
installPacman mc
installPacman thefuck
installPacman exa

# Docker
installPacman docker
installPacman docker-compose

# Node.js
installPacman node nodejs
installPacman npm

# TODO How to separate out graphical stuff?
sudo pacman -S --noconfirm ttf-hack

# set default shell to zsh
sudo chsh -s /usr/bin/zsh $USER

echo "All done!"
