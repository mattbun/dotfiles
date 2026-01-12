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

Prerequisites:

* `nix`
* `gnumake`

1. Use one of the two flake templates. The flake templates set up a `flake.nix` pointing to this repository and provide a `Makefile` to make it easy to apply changes.

    * `#default` (probably what you want) - only manages home configuration for the current user. Works on anything that can run nix.

        ```bash
        nix flake new -t github:mattbun/dotfiles destination-dir
        ```

    * `#nixos` - makes a directory structure for separate nixos and home configurations with their own flakes. The provided Makefile applies both configurations. You can combine the two flakes, but I find it works a little better for my usecases to keep them separate.

        ```bash
        nix flake new -t github:mattbun/dotfiles#nixos destination-dir
        ```

2. Open the directory

    ```bash
    cd destination-dir
    ```

3. Customize `home.nix` (`#default`) or `home/home.nix` (`#nixos`) to your liking

4. Apply configuration

    ```bash
    make
    ```
