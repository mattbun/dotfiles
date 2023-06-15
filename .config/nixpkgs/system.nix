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
    docker = false;
    graphical = false;
    kubernetes = false;
  };

  home.packages = with pkgs; [
    # mosh
  ];

  home.shellScripts = {
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
    "${homeDirectory}/.asdf/shims"
  ];
  appendedPaths = [
    # "${homeDirectory}/.bin"
  ];
}
