{ config
, pkgs
, nix-colors
, username
, homeDirectory
, lib
, ...
}:
let
  gitName = "Matt Rathbun";
  gitEmail = "5514636+mattbun@users.noreply.github.com";

  nix-colors-lib = nix-colors.lib-contrib { inherit pkgs; };
in
{
  imports = [
    nix-colors.homeManagerModule
  ];

  options = with lib; {
    additionalAliases = mkOption {
      type = with types; attrsOf string;
      description = "List of additional scripts";
      default = [ ];
    };

    additionalEnvVars = mkOption {
      type = with types; attrsOf string;
      description = "Additional environment variables to set";
      default = [ ];
    };

    additionalPackages = mkOption {
      type = with types; listOf package;
      description = "List of additional packages to install";
      default = [ ];
    };

    prependedPaths = mkOption {
      type = with types; listOf string;
      description = "Paths to prepend to the PATH environment variable";
      default = [ ];
    };

    appendedPaths = mkOption {
      type = with types; listOf string;
      description = "Paths to append to the PATH environment variable";
      default = [ ];
    };
  };

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = username;
    home.homeDirectory = homeDirectory;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      # base
      asdf-vm
      bat
      curl
      delta
      fd
      git
      glow
      gnutar
      gzip
      jq
      ripgrep
      rnix-lsp
      stylua
      sumneko-lua-language-server
      tmux
      unzip
      zsh
    ] ++ config.additionalPackages;

    colorScheme = nix-colors.colorSchemes.helios;
    # colorScheme = {
    #   slug = "...";
    #   name = "...";
    #   colors = {
    #     base00 = "000000"; # ----
    #     base01 = "000000"; # ---
    #     base02 = "000000"; # --
    #     base03 = "000000"; # -
    #     base04 = "000000"; # +
    #     base05 = "000000"; # ++
    #     base06 = "000000"; # +++
    #     base07 = "000000"; # ++++
    #     base08 = "000000"; # red
    #     base09 = "000000"; # orange
    #     base0A = "000000"; # yellow
    #     base0B = "000000"; # green
    #     base0C = "000000"; # aqua/cyan
    #     base0D = "000000"; # blue
    #     base0E = "000000"; # purple
    #     base0F = "000000"; # brown
    #   };
    # };

    nix = {
      enable = true;
      package = pkgs.nix;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "base16";
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      defaultOptions = [
        "--color=bg+:#${config.colorScheme.colors.base01}"
        "--color=bg:#${config.colorScheme.colors.base00}"
        "--color=spinner:#${config.colorScheme.colors.base0C}"
        "--color=hl:#${config.colorScheme.colors.base0D}"
        "--color=fg:#${config.colorScheme.colors.base04}"
        "--color=header:#${config.colorScheme.colors.base0D}"
        "--color=info:#${config.colorScheme.colors.base0A}"
        "--color=pointer:#${config.colorScheme.colors.base0C}"
        "--color=marker:#${config.colorScheme.colors.base0C}"
        "--color=fg+:#${config.colorScheme.colors.base06}"
        "--color=prompt:#${config.colorScheme.colors.base0A}"
        "--color=hl+:#${config.colorScheme.colors.base0D}"
      ];
    };

    programs.git = {
      enable = true;

      userName = gitName;
      userEmail = gitEmail;

      aliases = {
        s = "status";
        o = "open";
        last = "log -1 HEAD";
        main-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
        com = "!f(){ git checkout $(git main-branch) $@;}; f";
      };

      delta = {
        enable = true;
        options = {
          features = "line-numbers decorations";
        };
      };

      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        diff = {
          tool = "nvimdiff";
        };
        merge = {
          tool = "nvimdiff";
        };
        mergetool = {
          "vimdiff" = {
            path = "${pkgs.neovim}/bin/nvim";
          };
        };
        fetch = {
          prune = true;
        };
      };
    };

    xdg.configFile."nvim/init.lua".text = ''
      vim.cmd('source ~/.vimrc')
      vim.cmd('runtime colorscheme.vim')

      require("lsp")
      require("plugins")
      require("mappings")

      -- show substitutions
      vim.o.inccommand = "nosplit"
    '';

    programs.neovim = {
      enable = true;
    };

    programs.tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
        };
      };
    };

    programs.tmux = {
      enable = true;
      escapeTime = 0;
      historyLimit = 50000;

      plugins = with pkgs; [
        tmuxPlugins.logging
      ];

      extraConfig = ''
        # No status bar!
        set -g status off

        # Mouse mode!
        set -g mouse on

        # True Color!
        set -g default-terminal "screen-256color"
        set -ga terminal-overrides ",xterm-256color*:Tc"

        # Use zsh!
        set -g default-command "${pkgs.zsh}/bin/zsh"

        # Name windows after the current directory!
        set-option -g status-interval 5
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{b:pane_current_path}'
      '';
    };

    home.shellAliases = {
      # Make aliases work with sudo
      sudo = "sudo ";

      # neovim > vim
      vim = "nvim";
      vimdiff = "nvim -d";

      # misspellings
      gti = "git";
      tit = "echo 😱 && git";

      # git aliases, some of these are in oh-my-zsh/git but good to get them in bash too
      gcm = "git checkout $(git main-branch)";
      gdca = "git diff --cached";
      gpsup = "git push --set-upstream origin $(git_current_branch)";
    } // config.additionalAliases;

    home.sessionVariables = {
      EDITOR = "nvim";
      DIRENV_LOG_FORMAT = ""; # shh direnv
      FZF_DEFAULT_COMMAND = "rg --files --hidden --smart-case";
      RIPGREP_CONFIG_PATH = "~/.ripgreprc";

      # Generally you don't want to reference env vars like this in home-manager
      PATH = builtins.concatStringsSep ":" (config.prependedPaths ++ [ "$PATH" ] ++ config.appendedPaths);
    } // config.additionalEnvVars;

    # This works around some logic that tries to prevent reloading env vars
    home.sessionVariablesExtra = ''
      unset __HM_SESS_VARS_SOURCED
    '';

    programs.bash = {
      enable = true;
      initExtra = ''
        # Set up shell color scheme
        sh ${nix-colors-lib.shellThemeFromScheme { scheme = config.colorScheme; }}
      '';
    };

    programs.zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      dotDir = ".config/zsh";

      initExtra = ''
        # Set up shell color scheme
        sh ${nix-colors-lib.shellThemeFromScheme { scheme = config.colorScheme; }}

        # Set up powerlevel10k, this should always come last
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';

      zplug = {
        enable = true;
        plugins = [
          {
            name = "plugins/asdf";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "plugins/git";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "plugins/git-auto-fetch";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "paulirish/git-open";
            tags = [ "as:plugin" ];
          }
          {
            name = "romkatv/powerlevel10k";
            tags = [ "as:theme" "depth:1" ];
          }
          {
            name = "agkozak/zsh-z";
          }
        ];
      };
    };
  };
}
