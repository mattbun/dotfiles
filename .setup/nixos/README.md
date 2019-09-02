# Getting Started

1. Import the .nix files in this folder in /etc/nixos/configuration.nix like this:

```
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/matt/.setup/nixos/base.nix       # Basic cli tools and 'matt' user
      /home/matt/.setup/nixos/dev.nix        # Install tools I use for development like node and docker
      /home/matt/.setup/nixos/graphical.nix  # Install packages for a graphical environment like plasma and web browser
    ];
```

2. Run the `installZplug` script here to install zplug
