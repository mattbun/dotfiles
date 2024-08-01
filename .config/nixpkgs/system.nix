# System-specific configuration. Configs that should be applied to all systems should go in home.nix
{ pkgs
, config
, ...
}:
{
  # 04-white, 08-red, 09-orange, 0A-yellow, 0B-green, 0C-cyan, 0D-blue, 0E-magenta
  colorScheme.accentColor = config.colorScheme.palette.base04;

  packageSets = {
    # Development
    docker = false;
    kubernetes = false;

    # Desktops
    sway.enable = false;
  };

  programs = {
    # Shells
    bash.enable = true;
    fish.enable = true;

    # Editors
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # Utilities
    bat.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    git.delta.enable = true;
    mise.enable = true; # asdf clone
    ripgrep.enable = true;
    tealdeer.enable = false; # tldr

    # Terminals
    alacritty.enable = false;
    foot.enable = false;
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
  path = {
    prepend = [
      # "${config.home.homeDirectory}/.bin"
    ];
    append = [
      # "${config.home.homeDirectory}/.bin"
    ];
  };
}
