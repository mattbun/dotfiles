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
    ./system.nix
    ./colors/alacritty.nix
    ./colors/fzf.nix
    ./colors/k9s.nix
    ./colors/tmux.nix
    ./colors/vim.nix
    ./lib/scripts.nix
    ./lib/search.nix
    ./packages/docker.nix
    ./packages/graphical.nix
    ./packages/kubernetes.nix
  ];

  options = with lib; {
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
      bat
      curl
      delta
      fd
      git
      git-open
      glow
      gnused
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
    ];

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

    # These options apply to ripgrep and fd (which are used in fzf and neovim)
    # Implemented in ./lib/search.nix
    bun.search = {
      includeHidden = true;
      includeGitignored = false;
      ignoredPaths = [
        ".git"
      ];
      includedPaths = [
        ".env"
      ];
    };

    programs.fzf.enable = true;

    programs.ripgrep = {
      enable = true;
      arguments = [
        # "Searches case insensitively if the pattern is all lowercase. Search case sensitively otherwise."
        "--smart-case"
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
        push = {
          autoSetupRemote = true;
        };
      };
    };

    xdg.configFile."nvim/init.lua".text = ''
      vim.cmd('source ~/.vimrc')

      require("lsp")
      require("plugins")
      require("mappings")

      -- show substitutions
      vim.o.inccommand = "nosplit"
    '';

    programs.neovim = {
      enable = true;

      # The colorscheme needs to be loaded before lualine is started
      extraLuaConfig = ''
        vim.cmd('runtime colorscheme.vim')
      '';

      plugins = with pkgs.vimPlugins; [
        cmp-buffer
        cmp-calc
        cmp-emoji
        cmp-nvim-lsp
        cmp-path
        cmp-vsnip
        friendly-snippets
        glow-nvim
        mkdir-nvim
        nvim-lspconfig
        plenary-nvim
        telescope-fzf-native-nvim
        vim-eunuch
        vim-graphql
        vim-nix
        vim-terraform
        vim-vsnip
        vim-vsnip-integ

        {
          plugin = gitlinker-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/gitlinker.lua;
        }
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/gitsigns.lua;
        }
        {
          plugin = indent-blankline-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/indent-blankline.lua;
        }
        {
          plugin = kommentary;
          type = "lua";
          config = builtins.readFile ./nvim/kommentary.lua;
        }
        {
          plugin = lualine-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/lualine.lua;
        }
        {
          plugin = null-ls-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/null-ls.lua;
        }
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./nvim/cmp.lua;
        }
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ./nvim/nvim-tree.lua;
        }
        {
          plugin = switch-vim;
          type = "lua";
          config = builtins.readFile ./nvim/switch.lua;
        }
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/telescope.lua;
        }
      ];
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

        # Use fish!
        set -g default-command "${pkgs.fish}/bin/fish"

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
      gpsup = "git push --set-upstream origin $(git branch --show-current)";

      # easier to remember commands that search everything
      fda = "fd --no-ignore --hidden";
      rga = "rg --no-ignore --hidden";
    };

    # Implemented in ./lib/scripts.nix
    bun.shellScripts = {
      nxx = ''
        # Creates a nix-shell with the first argument as package and command to run.
        # Example: `nxx htop`
        nix-shell -p $1 --command "$1 ''${@:2}"
      '';

      nfx = ''
        # Creates a nix shell with the first argument as package and command to run.
        # Example: `nfx htop`
        nix shell nixpkgs#$1 --command $1 ''${@:2}
      '';

      nixify = ''
        if [ ! -e ./.envrc ]; then
          echo "use nix" > .envrc
          direnv allow
        fi

        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
          cat > shell.nix <<'EOF'
        with import <nixpkgs> {};
        mkShell {
          nativeBuildInputs = [
            bashInteractive
          ];
        }
        EOF
          ''${EDITOR:-vim} shell.nix
        fi
      '';

      flakify = ''
        if [ ! -d .git ]; then
          git init
        fi

        if [ ! -e flake.nix ]; then
          nix flake new -t github:nix-community/nix-direnv .
          direnv allow
        elif [ ! -e .envrc ]; then
          echo "use flake" > .envrc
          direnv allow
        fi

        ''${EDITOR:-vim} flake.nix
      '';

      git-pr = ''
        ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"} "$(git-open --print | sed -e 's|/tree/|/pull/new/|')"
      '';
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      DIRENV_LOG_FORMAT = ""; # shh direnv
      _ZL_HYPHEN = 1; # Tell z.lua to treat hyphens like normal characters and not part of a regex

      # Generally you don't want to reference env vars like this in home-manager
      PATH = builtins.concatStringsSep ":" (config.prependedPaths ++ [ "$PATH" ] ++ config.appendedPaths);
    };

    # This works around some logic that tries to prevent reloading env vars
    home.sessionVariablesExtra = ''
      unset __HM_SESS_VARS_SOURCED
    '';

    # z
    programs.z-lua = {
      enable = true;
    };

    # asdf clone
    programs.rtx = {
      enable = true;
    };

    programs.bash = {
      enable = true;
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
            name = "plugins/git";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "plugins/git-auto-fetch";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "romkatv/powerlevel10k";
            tags = [ "as:theme" "depth:1" ];
          }
        ];
      };
    };

    programs.fish = {
      enable = true;
      shellAbbrs = { };

      interactiveShellInit = ''
        sh ${nix-colors-lib.shellThemeFromScheme { scheme = config.colorScheme; }}
      '';

      functions = {
        fish_greeting = "";
      };

      plugins = [ ];
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$status"
          "$character"
        ];
        username = {
          format = "[$user]($style)";
          style_user = "bright-black";
          style_root = "red";
        };
        hostname = {
          format = "[@$hostname]($style) ";
          style = "bright-black";
        };
        directory = {
          style = "blue";
          read_only = " [RO]";
        };
        git_branch = {
          format = "[$branch]($style) ";
          style = "bright-black";
        };
        git_status = {
          format = "[$modified$untracked](bright-black)[$deleted](dimmed green)[$staged$renamed](green)[$conflicted](yellow)[$ahead_behind](cyan)";

          staged = "+$count ";
          deleted = "×$count ";
          renamed = "~$count ";

          conflicted = "=$count ";
          modified = "!$count ";
          untracked = "?$count ";

          ahead = "⇡$count ";
          behind = "⇣$count ";
          diverged = "$ahead_count⇕$behind_count ";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
        status = {
          format = "[$common_meaning$signal_name\\($status\\)]($style) ";
          pipestatus_format = "$pipestatus|$common_meaning$signal_name\\($status\\)]($style) ";
          disabled = false;
        };
        character = {
          success_symbol = "\\$";
          error_symbol = "[\\$](red)";
        };
      };
    };
  };
}
