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
    zk.enable = true;

    # AI Utilities
    aichat = {
      enable = false;
      # Model-specific settings can be added like this
      # clients.local.models."some-model:2b".supports_vision = true;
    };
    aider.enable = false;
    neovim.codecompanion.enable = false;
    neovim.minuet = {
      # minuet provides AI completions for providers other than copilot
      enable = false;
      # ollama doesn't configure minuet automatically though
      # settings = {
      #   provider = "openai_fim_compatible";
      #   provider_options = {
      #     openai_fim_compatible = {
      #       api_key = "TERM";
      #       name = "ollama";
      #       end_point = "${config.programs.ollama.connections.local.url}/v1/completions";
      #       model = "some-model:2b";
      #       optional = {
      #         max_tokens = 128;
      #         top_p = 0.9;
      #       };
      #     };
      #   };
      # };
    };
    ollama = {
      # Only installs ollama client, not the server
      enable = false;
      # defaultModel = "some-model:2b";
      # connections = {
      #   local = {
      #     url = "http://localhost:11434";
      #     models = {
      #       chat = [
      #         "some-model:2b"
      #       ];
      #       embedding = [ ];
      #       reranker = [ ];
      #     };
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

  wayland.customWindowManager.niri.enable = false;
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
