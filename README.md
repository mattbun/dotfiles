# It's Matt's dotfiles!

## Starring configurations for...

* [fish](https://fishshell.com/)
* [neovim](https://neovim.io/) (configured almost entirely in lua!)
* [tmux](https://github.com/tmux/tmux)
* [sway](https://swaywm.org/)
* [niri](https://github.com/YaLTeR/niri)
* ... and [a lot more](https://github.com/mattbun/dotfiles/tree/main/.config/nixpkgs/packages)!

## It's Nix!

The configuration in this repo relies on [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager). That doesn't mean it only works on NixOS! I've also used it in macOS (with [nix-darwin](https://github.com/LnL7/nix-darwin)), Arch Linux, and ChromeOS's Crostini.

### Why do all of the nix commands use `--impure`?

So I don't have to hard-code the system architecture, username, or home directory. The nix configurations in this repo rely on `builtins.currentSystem` and `builtins.getEnv` which don't work in pure evaluations with flakes.

## Getting Started

Clone this repo anywhere you'd like.

### Check out `.config/nixpkgs/system.nix`

> [!IMPORTANT]
> If you don't want your git commits to look like they come from me, change the git `userName` and `userEmail` at the top of `.config/nixpkgs/system.nix`.

[`.config/nixpkgs/system.nix`](https://github.com/mattbun/dotfiles/blob/main/.config/nixpkgs/system.nix) is where system-specific configuration lives. Use it to set an accent color, enable/disable applications, or override configurations from other modules in this repo.

### Installation

Install nix, install home-manager, and apply the home-manager configuration with

```shell
make install
```

Once installed, you can apply any changes with

```shell
make
```

### OS-Specific Instructions

#### Arch Linux

> [!WARNING]
> These instructions may be out-of-date.

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

#### Mac

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
