# Options you'll likely want to verify/update are indicated with `TODO`
{ config, pkgs, ... }: {
  # Set an accent color to be used in various places. Use any of the ANSI color names.
  # "orange" can also be used, but it falls back to a similar ANSI color when necessary.
  colorScheme.accent = "white"; # TODO

  programs = {
    # Git configuration, be sure to update the user name and email!
    git = {
      enable = true;
      settings.user = {
        # name = "Your Name"; # TODO
        # email = "your@email"; # TODO
      };
    };

    # Shell and editor
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # Utilities
    bat.enable = true;
    bottom.enable = true;
    fd.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
    tmux = {
      enable = true;
      shell = "${pkgs.fish}/bin/fish";
      captureDirectory = "${config.home.homeDirectory}/screenshots"; # TODO
    };

    # Terminals
    alacritty.enable = false;
    foot.enable = false;

    # Web browser
    firefox.enable = false;
  };

  # Wayland desktops
  wayland = {
    customWindowManager.niri.enable = false;
    windowManager.sway.enable = false;
  };

  home = {
    # Packages to install globally
    packages = with pkgs; [ ];

    # Global environment variables
    sessionVariables = {
      # COOL = "stuff";
    };
  };

  # Shell scripts that will be added to the nix store and PATH
  bun.shellScripts = {
    # beep = "echo 'boop'";
  };

  # Where to clone/create repos when using `git grab` and `git scratch` scripts.
  bun.paths.repos = "${config.home.homeDirectory}/src"; # TODO

  # These will be added to the PATH environment variable
  path = {
    prepend = [
      # "${config.home.homeDirectory}/.bin"
    ];
    append = [
      # "${config.home.homeDirectory}/.bin"
    ];
  };
}
