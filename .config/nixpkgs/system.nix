# System-specific configuration. Configs that should be applied to all systems should go in home.nix
{ pkgs
, config
, ...
}:
{
  colorScheme.accent = "white";

  programs = {
    # Shells
    bash.enable = true;
    fish.enable = true;

    # Editors
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    helix.enable = false;

    # Utilities
    bat.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    git.delta.enable = true;
    mise.enable = true; # asdf clone
    ripgrep.enable = true;
    tealdeer.enable = false; # tldr
    tmux = {
      enable = true;
      shell = "${pkgs.fish}/bin/fish";
    };

    # AI Utilities
    aichat.enable = false;
    neovim.codecompanion.enable = false;
    ollama = {
      # Only sets up ollama clients, not the server
      enable = false;
      # defaultModel = "local:some-model:2b";
      # connections = {
      #   local = {
      #     url = "http://localhost:11434";
      #     models = [
      #       "some-model:2b"
      #     ];
      #   };
      # };
    };

    # Terminals
    alacritty.enable = false;
    foot.enable = false;
  };

  packageSets = {
    # Development
    docker = false;
    kubernetes = false;
  };

  wayland.windowManager = {
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
  path = {
    prepend = [
      # "${config.home.homeDirectory}/.bin"
    ];
    append = [
      # "${config.home.homeDirectory}/.bin"
    ];
  };
}
