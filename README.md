# It's Matt's dotfiles!

## Starring configurations for...

* [fish](https://fishshell.com/)
* [neovim](https://neovim.io/) (configured almost entirely in lua!)
* [tmux](https://github.com/tmux/tmux)
* [alacritty](https://github.com/alacritty/alacritty)
* [sway](https://swaywm.org/)
* ... and [more](https://github.com/mattbun/dotfiles/tree/main/.config/nixpkgs/packages)!

## It's Nix!

The configuration in this repo relies on [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager). That doesn't mean it only works on NixOS! I've also used it in macOS (with [nix-darwin](https://github.com/LnL7/nix-darwin)), Arch Linux, and ChromeOS's Crostini.

### Why do all of the nix commands use `--impure`?

So I don't have to hard-code the system architecture, username, or home directory. The nix configurations in this repo rely on `builtins.currentSystem` and `builtins.getEnv` which don't work in pure evaluations with flakes.

## Getting Started

### Cloning this repo

Nix and Home Manager should be able to handle this repo being cloned anywhere, but I usually clone it to my home directory with:

```shell
cd
git init
git remote add origin git@github.com:mattbun/dotfiles.git
git fetch
git checkout main
```

### NixOS

It's possible to use Home Manager's NixOS module to hook this into the system config, but I like to keep them separate for simplicity's sake.

1. Install and set up home-manager

    ```shell
    # If make is already installed
    make install

    # Or you can use the configuration in shell.nix to create an ephemeral shell with 'make' in it
    nix-shell --command "make install"
    ```

2. From here on, to apply configuration changes run

    ```shell
    make
    ```

### Arch Linux

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

### Mac

1. [Install homebrew](https://brew.sh/)

2. [Install nix](https://nix.dev/tutorials/install-nix)

3. Install dependencies and get everything set up

    ```
    # If make is installed
    make install

    # Or you can use the configuration in shell.nix to create an ephemeral shell with 'make' in it
    nix-shell --command "make install"
    ```

4. From here on, to apply configuration changes run

    ```shell
    make
    ```

Note: some of the `system.defaults` options in `darwin.nix` require a Finder or Dock restart to take effect.
