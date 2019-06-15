#!/bin/bash

pacman --noconfirm -Sy zsh neovim curl git nodejs npm ripgrep thefuck docker docker-compose

# For graphical install this font
# pacman -S ttf-hack

# Install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
