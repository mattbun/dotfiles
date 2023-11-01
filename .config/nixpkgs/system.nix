# System-specific configuration. Configs that should be applied to all systems should go in home.nix
{ pkgs
, config
, ...
}:
let
  homeDirectory = config.home.homeDirectory;
in
{
  packageSets = {
    # Development
    docker = false;
    kubernetes = false;

    # Terminals
    alacritty.enable = false;
    foot.enable = false;

    # Desktops
    sway.enable = false;
  };

  home.packages = with pkgs; [
    # mosh
  ];

  bun.shellScripts = {
    # beep = "echo 'boop'";
  };

  home.shellAliases = {
    # wow = "echo neat";
  };

  home.sessionVariables = {
    # COOL = "stuff";
  };

  # These will be added to the PATH environment variable
  prependedPaths = [
    # "${homeDirectory}/.bin"
  ];
  appendedPaths = [
    # "${homeDirectory}/.bin"
  ];
}
