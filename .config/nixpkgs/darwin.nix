{ config, pkgs, ... }:

let
  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
in
{
  users.users."${username}" = {
    name = username;
    home = homeDirectory;
  };

  homebrew = {
    enable = true;

    brews = [
      "colima" # docker desktop alternative
      "docker"
      "docker-compose"
      "yarn"
    ];

    casks = [
      "alacritty"
      "homebrew/cask-fonts/font-hack"
    ];
  };

  system = {
    defaults = {
      # Dark mode always
      NSGlobalDomain.AppleInterfaceStyle = "Dark";

      # Don't show icons on the Desktop
      finder.CreateDesktop = false;

      # Save screenshots to another location, you may need to do a `mkdir -p ~/Pictures/Screenshots`
      screencapture.location = "~/Pictures/Screenshots";

      dock = {
        # Don't show recent apps in Dock
        show-recents = false;

        # Don't rearrange spaces based on most recent use
        mru-spaces = false;
      };
    };

    # WHO NEEDS CAPSLOCK?
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  # TODO Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
