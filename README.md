# It's Matt's dotfiles!

## Starring configurations for...

* [zsh](https://zsh.sourceforge.io/)
* [neovim](https://neovim.io/) (configured almost entirely in lua!)
* [tmux](https://github.com/tmux/tmux)
* [alacritty](https://github.com/alacritty/alacritty)
* ... and more!

## And that's not all!

* A common color scheme provided by [nix-colors](https://github.com/Misterio77/nix-colors)
* Fallback configurations for bash and regular ol' vim
* [direnv](https://direnv.net/) *and* [nix-direnv](https://github.com/nix-community/nix-direnv)

## Sign me up!

First, you need to clone the repo. I clone it directly to my home directory:

```shell
cd
git init
git remote add origin git@github.com:mattbun/dotfiles.git
git fetch
git checkout main
```

### Nix!

The configuration in this repo relies on [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager). That doesn't mean it only works on NixOS! I also use it in macOS (with [nix-darwin](https://github.com/LnL7/nix-darwin)) and in Arch Linux.

#### Installation (Arch Linux)

1. Install nix

    ```shell
    sudo pacman -S nix
    ```

2. Enable nix-daemon

    ```shell
    sudo systemctl enable nix-daemon
    ```

3. Add user to nix-users group

    ```shell
    sudo gpasswd -a matt nix-users
    ```

4. Log out and back in again for the group change to take effect.

5. Install home-manager and get everything set up

    ```shell
    # If make is installed
    make install

    # Or you can use the configuration in shell.nix to create an ephemeral shell with 'make' in it
    nix-shell --command "make install"
    ```

6. From here on, to apply configuration changes run

    ```shell
    make
    ```
