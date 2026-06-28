{ ... }: {
  system = {
    defaults = {
      # Dark mode always
      NSGlobalDomain.AppleInterfaceStyle = "Dark";

      # Don't show icons on the Desktop
      finder.CreateDesktop = false;

      # Save screenshots to another location, you may need to do a `mkdir -p ~/Pictures/Screenshots`
      screencapture.location = "~/Pictures/Screenshots";

      # Setting clock to 24-hour time makes screenshots sort alphabetically
      NSGlobalDomain.AppleICUForce24HourTime = true;

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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
