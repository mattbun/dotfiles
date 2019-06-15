# You'll need to generate an ssh key in order to clone the dotfiles:
#   ssh-keygen -t rsa -C "matt@rathbun.cc" -b 4096

# pacman --noconfirm -Sy zsh neovim curl git nodejs npm ripgrep thefuck docker docker-compose

# TODO ripgrep
# TODO docker (ugh docker in debian is something else)
# TODO get a newer nodejs

apt-get install -y neovim python-pip python3-pip zsh curl git thefuck docker-compose

# python support for neovim
pip2 install --user neovim
pip3 install --user neovim

# Install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
