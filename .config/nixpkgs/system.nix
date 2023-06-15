# System-specific configuration. Configs that should be applied to all systems should go in home.nix
{ pkgs
, homeDirectory
, ...
}: {
  packageSets = {
    docker = false;
    graphical = false;
    kubernetes = false;
  };

  additionalPackages = with pkgs; [
    # mosh
  ];

  additionalScripts = {
    # beep = "echo 'boop'";
  };

  additionalAliases = {
    # wow = "echo neat";
  };

  additionalEnvVars = {
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
