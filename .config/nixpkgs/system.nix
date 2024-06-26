# System-specific configuration. Configs that should be applied to all systems should go in home.nix
{ pkgs
, config
, ...
}:
let
  homeDirectory = config.home.homeDirectory;
in
{
  # 04-white, 08-red, 09-orange, 0A-yellow, 0B-green, 0C-cyan, 0D-blue, 0E-magenta
  colorScheme.accentColor = config.colorScheme.palette.base04;

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

  # Additional treesitter grammars for neovim
  programs.neovim.plugins = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    # go
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
      # "${homeDirectory}/.bin"
    ];
    append = [
      # "${homeDirectory}/.bin"
    ];
  };
}
