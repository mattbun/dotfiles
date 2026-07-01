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

### Creating a new flake with the template

Prerequisites:

* `nix`
* `gnumake`

1. Use the flake template:

    ```bash
    nix flake new -t github:mattbun/dotfiles destination-dir
    ```

2. Open the directory

    ```bash
    cd destination-dir
    ```

3. Customize `home.nix` to your liking

4. Apply configuration

    ```bash
    make
    ```

### Adding to an existing home-manager flake

```nix
{
  inputs = {
    # ...

    # Add to inputs
    dotfiles.url = "github:mattbun/dotfiles";
  };

  outputs = { dotfiles, ... }: {
      homeConfigurations.matt = home-manager.lib.homeManagerConfiguration {
        # ...

        modules = [
          # ...

          # Add to modules
          dotfiles.homeModule
        ];
      };
    };
}
```

See [templates/default/flake.nix](https://github.com/mattbun/dotfiles/blob/main/templates/default/flake.nix) for a full example.
